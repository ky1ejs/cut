import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

export const getProfileById: QueryResolvers["profileById"] = async (_, args) => {
  const result = await prisma.user.findUnique({
    where: {
      id: args.id
    }
  })

  return result
}

export const getProfileByUsername: QueryResolvers["profileByUsername"] = async (_, args) => {
  const result = await prisma.user.findUnique({
    where: {
      username: args.username
    }
  })

  return result
}
