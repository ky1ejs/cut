import exp from "constants";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import dbMovieToGqlMovie, { movieInclude } from "../mappers/dbMovieToGqlMovie";
import ContentID from "../../types/ContentID";

const rate: MutationResolvers['rate'] = async (_, args, context) => {
  const rating = Math.max(0, Math.min(5, args.rating))
  const contentId = ContentID.fromString(args.contentId)
  if (context.userDevice) {
    const watchListDelete = prisma.watchList.delete({
      where: {
        movieId_userId: {
          movieId: contentId.id,
          userId: context.userDevice.user.id
        }
      }
    }).catch(() => { }) // ignore error
    const ratingCreate = prisma.rating.create({
      data: {
        movieId: contentId.id,
        userId: context.userDevice.user.id,
        rating: rating
      },
      include: {
        movie: {
          include: movieInclude
        }
      }
    })
    const [_, { movie }] = await Promise.all([watchListDelete, ratingCreate])
    return {
      ...dbMovieToGqlMovie(movie),
      isOnWatchList: false,
      rating: rating
    }
  } else if (context.annonymousUserDevice) {
    const watchListDelete = prisma.annonymousWatchList.delete({
      where: {
        movieId_userId: {
          movieId: contentId.id,
          userId: context.annonymousUserDevice.id
        }
      }
    }).catch(() => { }) // ignore error
    const ratingCreate = prisma.annonymousRating.create({
      data: {
        movieId: contentId.id,
        userId: context.annonymousUserDevice.id,
        rating: rating
      },
      include: {
        movie: {
          include: movieInclude
        }
      }
    })
    const [_, { movie }] = await Promise.all([watchListDelete, ratingCreate])
    return {
      ...dbMovieToGqlMovie(movie),
      isOnWatchList: false,
      rating: rating
    }
  } else {
    throw new Error('Unauthorized')
  }
}

export default rate
