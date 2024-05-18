import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { mapProfile } from "../mappers/profileMapper";

const unfollow: MutationResolvers["unfollow"] = async (_, args, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized")
  }

  const result = await prisma.follow.delete({
    where: {
      followerId_followingId: {
        followerId: context.userDevice.user.id,
        followingId: args.userId
      }
    }
  })
  const unfollowedUser = await prisma.user.findUniqueOrThrow({ where: { id: args.userId } })
  return mapProfile(unfollowedUser, false, false)
}

export default unfollow;
