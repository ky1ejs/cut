import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { mapProfile } from "../mappers/profileMapper";

export const getProfileById: QueryResolvers["profileById"] = async (_, args, context) => {
  const result = await prisma.user.findUnique({
    where: {
      id: args.id
    }
  })

  const id = context.userDevice?.userId || context.annonymousUserDevice?.userId

  if (result) {
    const mappedProfile = mapProfile(result, undefined)
    return {
      ...mappedProfile,
      __typename: id === result.id ? "CompleteAccount" : "Profile"
    }
  }

  return null
}

export const getProfileByUsername: QueryResolvers["profileByUsername"] = async (_, args) => {
  const result = await prisma.user.findUnique({
    where: {
      username: args.username
    }
  })

  if (result) {
    return mapProfile(result, undefined)
  }
  return null
}
