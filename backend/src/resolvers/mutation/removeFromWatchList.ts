import exp from "constants";
import { MutationRemoveFromWatchListArgs, MutationResolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import { Prisma } from "@prisma/client";

const removeFromWatchList: MutationResolvers["addToWatchList"] = async (_, args, context) => {
  if (!context.user) {
    throw new Error('Unauthorized');
  }

  const [providerOrCutId, movieId] = args.movieId.split(':');
  let resolvedMovieId: string
  switch (providerOrCutId) {
    case 'TMDB':
      const movie = await prisma.movie.findUnique({
        where: {
          tmdbId: parseInt(movieId)
        }
      });
      if (!movie) {
        throw new Error('Movie not found');
      }
      resolvedMovieId = movie.id;
      break;
    default:
      const cutMovieId = movieId || providerOrCutId
      if (!cutMovieId) {
        throw new Error('Missing movieId');
      }
      resolvedMovieId = cutMovieId;
      break;
  }

  await prisma.watchList.delete({
    where: {
      movieId_userId: {
        movieId: resolvedMovieId,
        userId: context.user.id
      }
    }
  })

  return {
    true: true,
    id: resolvedMovieId
  }
}

export default removeFromWatchList;
