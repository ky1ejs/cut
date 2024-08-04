import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import contentDbToGqlMapper, { contentInclude } from "../mappers/contentDbToGqlMapper";
import ContentID from "../../types/ContentID";

const rate: MutationResolvers['rate'] = async (_, args, context) => {
  console.log("CALLING RATE")
  const rating = Math.max(0, Math.min(5, args.rating))
  const contentId = ContentID.fromString(args.contentId)
  if (context.userDevice) {
    const watchListDelete = prisma.watchList.delete({
      where: {
        contentId_userId: {
          contentId: contentId.id,
          userId: context.userDevice.user.id
        }
      }
    }).catch(() => { }) // ignore error
    const ratingCreate = prisma.rating.create({
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
    const [_, { content }] = await Promise.all([watchListDelete, ratingCreate])
    return {
      content: {
        ...contentDbToGqlMapper(content),
        isOnWatchList: false,
        rating: rating
      }
    }
  } else if (context.annonymousUserDevice) {
    const watchListDelete = prisma.annonymousWatchList.delete({
      where: {
        contentId_userId: {
          contentId: contentId.id,
          userId: context.annonymousUserDevice.id
        }
      }
    }).catch(() => { }) // ignore error
    const ratingCreate = prisma.annonymousRating.create({
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
    const [_, { content }] = await Promise.all([watchListDelete, ratingCreate])
    console.log("FINISHED")
    return {
      content: {
        ...contentDbToGqlMapper(content),
        isOnWatchList: false,
        rating: rating
      }
    }
  } else {
    throw new Error('Unauthorized')
  }
}

export default rate
