import { CompleteAccount, IncompleteAccount, QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";

const getAccount: QueryResolvers["account"] = async (_, __, context) => {
  if (context.userDevice) {
    const userWithFollowing = await prisma.user.findUniqueOrThrow({
      where: { id: context.userDevice.user.id },
      include: {
        followers: {
          include: {
            follower: true
          }
        },
        following: {
          include: {
            following: true
          }
        }
      }
    })

    const completeUser: Partial<CompleteAccount> = {
      id: userWithFollowing.id,
      username: context.userDevice.user.username,
      name: context.userDevice.user.name,
      bio: context.userDevice.user.bio,
      url: context.userDevice.user.url,
      followers: userWithFollowing.followers.map(u => ({ id: u.follower.id, username: u.follower.username, profileUrl: null })),
      following: userWithFollowing.following.map(u => ({ id: u.following.id, username: u.following.username, profileUrl: null })),
      followerCount: userWithFollowing.followers.length,
      followingCount: userWithFollowing.following.length,
      __typename: "CompleteAccount"
    }
    return completeUser
  } else if (context.annonymousUserDevice) {
    const incompleteUser: Partial<IncompleteAccount> = {
      id: context.annonymousUserDevice.user.id,
      __typename: "IncompleteAccount"
    }
    return incompleteUser
  }

  throw new GraphQLError("Unauthorized")
}

export default getAccount;
