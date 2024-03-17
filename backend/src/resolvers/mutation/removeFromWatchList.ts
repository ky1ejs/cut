import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";

const removeFromWatchList: MutationResolvers["addToWatchList"] = async (_, args, context) => {
  if (!context.userDevice && !context.annonymousUserDevice) {
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

  if (context.userDevice) {
    await prisma.watchList.delete({
      where: {
        movieId_userId: {
          movieId: resolvedMovieId,
          userId: context.userDevice.user.id
        }
      }
    })
  } else if (context.annonymousUserDevice) {
    await prisma.annonymousWatchList.delete({
      where: {
        movieId_userId: {
          movieId: resolvedMovieId,
          userId: context.annonymousUserDevice.user.id
        }
      }
    })
  } else {
    throw new GraphQLError('Runtime error');
  }

  return {
    true: true,
    id: resolvedMovieId
  }
}

export default removeFromWatchList;
