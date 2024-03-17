import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const unfollow: MutationResolvers["unfollow"] = async (_, args, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized")
  }

  await prisma.follow.delete({
    where: {
      followerId_followingId: {
        followerId: context.userDevice.user.id,
        followingId: args.userId
      }
    }
  })

  return true
}

export default unfollow;
