import { User } from "@prisma/client";
import { CompleteAccount, IncompleteAccount, Profile, ProfileInterface, QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";
import { profileImageUrl } from "../mappers/cdnUrls";

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

    const phoneNumber = userWithFollowing.phoneNumber ? `${(context.userDevice.user.countryCode) ? `+${context.userDevice.user.countryCode}` : ""}${context.userDevice.user.phoneNumber}` : null
    const completeUser: Partial<CompleteAccount> = {
      id: userWithFollowing.id,
      username: context.userDevice.user.username,
      name: context.userDevice.user.name,
      bio: context.userDevice.user.bio,
      bio_url: context.userDevice.user.url,
      phoneNumber,
      followerCount: userWithFollowing.followers.length,
      followingCount: userWithFollowing.following.length,
      share_url: "https://cut.watch/p/" + context.userDevice.user.username,
      __typename: "CompleteAccount",
      imageUrl: profileImageUrl(context.userDevice.user),
      isCurrentUser: true,
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
