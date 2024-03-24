import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const follow: MutationResolvers["follow"] = async (_, args, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized")
  }

  const data = {
    followerId: context.userDevice.user.id,
    followingId: args.userId
  }

  const result = await prisma.follow.upsert(
    {
      where: {
        followerId_followingId: data
      },
      create: data,
      update: {},
      include: {
        following: true
      }
    }
  )

  return result.following
}

export default follow;
