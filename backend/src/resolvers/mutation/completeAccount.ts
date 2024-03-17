import { GraphQLError } from "graphql";
import { MutationCompleteAccountArgs, MutationResolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import { decrypt } from "../../services/cipher";
import { hashPassword } from "../../services/bcrypt";

export const completeAccount = async (args: MutationCompleteAccountArgs, context: GraphQLContext) => {
  const { username, name, password, emailToken } = args.params

  if (!context.annonymousUserDevice) {
    throw new Error("Not authenticated")
  }

  if (context.userDevice) {
    throw new Error("User is already complete")
  }

  const decryptedEmailToken = decrypt(emailToken, process.env.EMAIL_ENCRYPTION_KEY)
  const [email, dateString] = decryptedEmailToken.split("#")
  const date = Date.parse(dateString)
  const thiryMinsInMillis = 1000 * 60 * 30
  if ((new Date().valueOf() - thiryMinsInMillis) > date.valueOf()) {
    throw new GraphQLError("Token expired")
  }

  const existingWatchList = await prisma.annonymousWatchList.findMany({
    where: { userId: context.annonymousUserDevice.user.id }
  })

  const [completedUser] = await prisma.$transaction([
    prisma.user.create({
      include: {
        devices: true,
      },
      data: {
        username: username,
        email: email,
        name: name,
        password: await hashPassword(password),
        createdAt: context.annonymousUserDevice.user.createdAt,
        watchList: {
          createMany: {
            data: existingWatchList.map(w => ({
              movieId: w.movieId,
              createdAt: w.createdAt
            })),
            skipDuplicates: false
          }
        },
        devices: {
          create: {
            name: context.annonymousUserDevice.name
          }
        }
      }
    }),
    prisma.anonymousUser.delete({ where: { id: context.annonymousUserDevice.user.id } }),
  ])

  const newDevice = completedUser.devices[0]

  context.annonymousUserDevice = undefined
  context.userDevice = {
    ...newDevice,
    user: completedUser
  }

  return {
    completeAccount: {
      id: completedUser.id,
      username: username,
      followers: [],
      following: [],
      followingCount: 0,
      followerCount: 0,
      watchList: [],
      name: completedUser.name,

    },
    updatedDevice: {
      name: completedUser.devices[0].name,
      session_id: completedUser.devices[0].sessionId
    }
  }
}

const completeAccountResolver: MutationResolvers["completeAccount"] = (_, args, context) => completeAccount(args, context)

export default completeAccountResolver;
