import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const isUsernameAvailable: QueryResolvers["isUsernameAvailable"] = async (_, args, context) => {
  if (!context.annonymousUserDevice && !context.userDevice) {
    throw new Error("Unauthorized")
  }

  if (args.username.length < 2) {
    throw new Error("Username must be at least 1 character long")
  }

  const user = await prisma.user.findUnique({ where: { username: args.username } })

  return user == null
}

export default isUsernameAvailable
