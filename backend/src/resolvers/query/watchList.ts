import { Genre as DbGenre, Movie as DbMovie, MovieImage, LocalizedGenre, MovieGenre, Prisma, User } from "@prisma/client";
import { CompleteAccountResolvers, Genre, IncompleteAccountResolvers, Movie, ProfileInterface, ProfileResolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import { GraphQLError, GraphQLResolveInfo } from "graphql";
import { movieInclude } from "../mappers/dbMovieToGqlMovie";
import { DeepPartial } from "utility-types";

enum UserType {
  INCOMPLETE,
  COMPLETE
}

export const incompleteAccountWatchList: IncompleteAccountResolvers["watchList"] = (_, __, context) => {
  if (!context.annonymousUserDevice) {
    throw new GraphQLError("User not authenticated");
  }
  return watchList(context.annonymousUserDevice.userId, UserType.INCOMPLETE);
}

export async function completeAccountWatchList(parent: DeepPartial<ProfileInterface>, context: GraphQLContext, info: GraphQLResolveInfo): Promise<Movie[]> {
  console.log(info)
  if (info.path.prev?.key === "account") {
    if (context.userDevice) {
      return watchList(context.userDevice.userId, UserType.COMPLETE);
    } else {
      throw new GraphQLError("User not authenticated");
    }
  } else if (parent.id) {
    return watchList(parent.id, UserType.COMPLETE);
  } else if (info.variableValues.id && typeof info.variableValues.id === "string") {
    return watchList(info.variableValues.id, UserType.COMPLETE);
  } else if (info.variableValues.username && typeof info.variableValues.username === "string") {
    const user = await prisma.user.findUnique({
      where: { username: info.variableValues.username }
    });
    if (user) {
      return watchList(user.id, UserType.COMPLETE);
    } else {
      throw new GraphQLError("User not found");
    }
  }
  throw new GraphQLError("Bad request");
}

export default async function watchList(userId: string, type: UserType) {
  const include = { movie: { include: movieInclude } }

  switch (type) {
    case UserType.COMPLETE:
      return prisma.watchList.findMany({
        where: { userId },
        include
      }).then((watchList) => watchList.map((watchListItem) => {
        return watchListGraphQLModel(watchListItem.movie);
      }));
    case UserType.INCOMPLETE:
      return prisma.annonymousWatchList.findMany({
        where: { userId },
        include
      }).then((watchList) => watchList.map((watchListItem) => {
        return watchListGraphQLModel(watchListItem.movie);
      }));
  }
}

function watchListGraphQLModel(movie: DbMovie & { images: MovieImage[], genres: (MovieGenre & { genre: DbGenre & { locales: LocalizedGenre[] } })[] }): Movie {
  const genres: Genre[] = movie.genres.map((genre) => {
    return {
      id: genre.genre.id,
      name: genre.genre.locales[0].name
    }
  });
  return {
    id: movie.id,
    title: movie.originalTitle,
    poster_url: movie.images[0].url,
    release_date: movie.releaseDate?.toString(),
    genres: genres,
    isOnWatchList: true
  }
}