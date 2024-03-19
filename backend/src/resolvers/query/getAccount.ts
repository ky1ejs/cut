import { User } from "@prisma/client";
import { CompleteAccount, IncompleteAccount, Profile, QueryResolvers } from "../../__generated__/graphql";
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
      followers: userWithFollowing.followers.map(f => profileMapper(f.follower)),
      following: userWithFollowing.following.map(f => profileMapper(f.following)),
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

function profileMapper(user: User): Profile {
  return {
    id: user.id,
    username: user.username,
    name: user.name,
    url: user.url,
    bio: user.bio,
  }
}

export default getAccount;
