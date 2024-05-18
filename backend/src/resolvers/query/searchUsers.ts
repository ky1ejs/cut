import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { mapProfileInterface } from "../mappers/profileMapper";

const searchUsers: QueryResolvers["searchUsers"] = async (_, args, context) => {
  if (context.userDevice === null || context.annonymousUserDevice === null) {
    throw new Error("Unauthorized");
  }
  if (!args.term) {
    return [];
  }
  const result = await prisma.user.findMany({
    where: {
      OR: [
        { name: { contains: args.term, mode: "insensitive" } },
        { username: { contains: args.term, mode: "insensitive" } },
      ]
    },
  });
  return result.map(u => {
    const userId = context.userDevice?.user.id || context.annonymousUserDevice?.user.id;
    const isCurrentUser = userId === u.id;
    return mapProfileInterface(u, isCurrentUser)
  })
}

export default searchUsers;
