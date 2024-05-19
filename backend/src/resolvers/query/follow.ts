import { User } from "@prisma/client";
import { FollowDirection, ProfileInterfaceResolvers, Query, QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { mapProfile } from "../mappers/profileMapper";

export const followersResolver: ProfileInterfaceResolvers["followers"] = async (parent, _, context) => {
  if (!parent.id) {
    return [];
  }
  return await followers(parent.id, context.userDevice?.user)
}

export const followingResolver: ProfileInterfaceResolvers["following"] = async (parent, _, context) => {
  if (!parent.id) {
    return [];
  }
  return await following(parent.id, context.userDevice?.user)
}

export const profileFollowResolver: QueryResolvers["profileFollow"] = async (_, args, context) => {
  switch (args.direction) {
    case FollowDirection.Follower:
      return await followers(args.id, context.userDevice?.user)
    case FollowDirection.Following:
      return await following(args.id, context.userDevice?.user)
  }
}

async function followers(userId: string, currentUser: User | undefined = undefined) {
  const followers = await prisma.follow.findMany({
    where: {
      followingId: userId
    },
    include: {
      follower: true
    }
  }).then(follows => follows.map(follow => follow.follower))

  return followers.map(f => mapProfile(f, false, currentUser))
}

async function following(userId: string, currentUser: User | undefined = undefined) {
  const following = await prisma.follow.findMany({
    where: {
      followerId: userId
    },
    include: {
      following: true
    }
  }).then(follows => follows.map(follow => follow.following))

  return following.map(f => mapProfile(f, false, currentUser))
}

