import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const isUsernameAvailable: QueryResolvers["isUsernameAvailable"] = async (_, args, context) => {
  const user = await prisma.user.findUnique({ where: { username: args.username } })
  return user == null
}

export default isUsernameAvailable
