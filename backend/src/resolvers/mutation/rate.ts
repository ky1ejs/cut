import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import contentDbToGqlMapper, { contentInclude } from "../mappers/contentDbToGqlMapper";
import ContentID from "../../types/ContentID";

const rate: MutationResolvers['rate'] = async (_, args, context) => {
  const rating = Math.max(0, Math.min(5, args.rating))
  const contentId = ContentID.fromString(args.contentId)
  if (context.userDevice) {
    await prisma.rating.delete({
      where: {
        contentId_userId: {
          contentId: contentId.id,
          userId: context.userDevice.user.id
        }
      }
    }).catch(() => { }) // ignore error
    const deleteWatchList = prisma.watchList.delete(
      {
        where: {
          contentId_userId: {
            contentId: contentId.id,
            userId: context.userDevice.user.id
          }
        }
      }
    ).catch(() => { }) // ignore error
    const rateMovie = prisma.rating.create({
      data: {
        contentId: contentId.id,
        userId: context.userDevice.user.id,
        rating: rating
      },
      include: {
        content: {
          include: contentInclude
        }
      }
    })
    const [, newRating] = await Promise.all([deleteWatchList, rateMovie])
    return {
      content: {
        ...contentDbToGqlMapper(newRating.content),
        isOnWatchList: false,
        rating
      }
    }
  } else if (context.annonymousUserDevice) {
    await prisma.annonymousRating.delete({
      where: {
        contentId_userId: {
          contentId: contentId.id,
          userId: context.annonymousUserDevice.id
        }
      }
    }).catch(() => { }) // ignore error
    const deleteWatchList = prisma.annonymousWatchList.delete(
      {
        where: {
          contentId_userId: {
            contentId: contentId.id,
            userId: context.annonymousUserDevice.id
          }
        }
      }
    ).catch(() => { }) // ignore error
    const rateMovie = prisma.annonymousRating.create({
      data: {
        contentId: contentId.id,
        userId: context.annonymousUserDevice.id,
        rating: rating
      },
      include: {
        content: {
          include: contentInclude
        }
      }
    })
    const [, newRating] = await Promise.all([deleteWatchList, rateMovie])
    return {
      content: {
        ...contentDbToGqlMapper(newRating.content),
        isOnWatchList: false,
        rating
      }
    }
  } else {
    throw new Error('Unauthorized')
  }
}

export default rate
