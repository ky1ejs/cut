import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const logIn: MutationResolvers["logIn"] = async (_, args, context) => {
  if (!context.annonymousUserDevice) {
    throw new GraphQLError("Unauthorized")
  }
  const id = await authenticateUser(args.username, args.password)
  const annonymousUsersWatchList = await prisma.watchList.findMany({ where: { userId: context.annonymousUserDevice.user.id } })

  if (annonymousUsersWatchList.length > 0) {
    prisma.$transaction([
      prisma.annonymousDevice.deleteMany({ where: { userId: context.annonymousUser.id } }),
      prisma.device.create({
        data: {
          userId: id,
          name: context.annonymousUser
        }
      })
    ])
  } else {
    const loggedInUsersWatchList = await prisma.watchList.findMany({ where: { userId: id } })
  }

}

async function authenticateUser(username: string, password: string): Promise<string> {
  const userByUsername = prisma.user.findUnique({ where: { username } })
  const userByEmail = prisma.user.findUnique({ where: { email: username } })
  const [usernameResult, emailResult] = await Promise.all([userByUsername, userByEmail])
  const id = usernameResult?.id || emailResult?.id
  if (!id) {
    throw new GraphQLError("Invalid username")
  }
  return id
}
