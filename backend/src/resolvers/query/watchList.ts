import { Genre as DbGenre, Movie as DbMovie, MovieImage, LocalizedGenre, MovieGenre, Prisma } from "@prisma/client";
import { Genre, Movie } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";

export default async function watchList(context: GraphQLContext) {
  const { userDevice, annonymousUserDevice } = context;

  const include = {
    movie: {
      include: {
        images: true,
        genres: {
          include: {
            genre: {
              include: {
                locales: {
                  where: {
                    language_ISO_639_1: "en"
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  if (userDevice) {
    return prisma.watchList.findMany({
      where: { userId: userDevice.user.id },
      include
    }).then((watchList) => watchList.map((watchListItem) => {
      return watchListGraphQLModel(watchListItem.movie);
    }));
  }
  if (annonymousUserDevice) {
    return prisma.annonymousWatchList.findMany({
      where: { userId: annonymousUserDevice.user.id },
      include
    }).then((watchList) => watchList.map((watchListItem) => {
      return watchListGraphQLModel(watchListItem.movie);
    }));
  }
  throw new GraphQLError("Unauthorized");
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