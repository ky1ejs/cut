import { ContentInterfaceResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { mapProfile } from "../mappers/profileMapper";

const followerRatings: ContentInterfaceResolvers["followingRatings"] = async (parent, args, context) => {
  if (!context.userDevice) return []
  const result = await prisma.rating.findMany(
    {
      where: {
        user: {
          followers: {
            every: {
              followerId: context.userDevice.userId
            }
          }
        }
      },
      include: {
        user: true,
      }
    }
  )
  return result.map(r => ({
    rating: r.rating,
    user: mapProfile(r.user, true, undefined),
    contentId: r.contentId
  }))
}

export default followerRatings;
