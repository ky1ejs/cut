import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { mapProfile } from "../mappers/profileMapper";

export const getProfileById: QueryResolvers["profileById"] = async (_, args, context) => {
  const result = await prisma.user.findUnique({
    where: {
      id: args.id
    }
  })

  if (result) {
    const userId = context.userDevice?.userId || context.annonymousUserDevice?.userId
    const isCurrentUser = userId === result.id
    const mappedProfile = mapProfile(result, undefined, context.userDevice?.user)
    return {
      ...mappedProfile,
      __typename: isCurrentUser ? "CompleteAccount" : "Profile"
    }
  }

  throw new Error("User not found")
}

export const getProfileByUsername: QueryResolvers["profileByUsername"] = async (_, args, context) => {
  const result = await prisma.user.findUnique({
    where: {
      username: args.username
    }
  })

  if (result) {
    return mapProfile(result, undefined, context.userDevice?.user)
  }
  throw new Error("User not found")
}
