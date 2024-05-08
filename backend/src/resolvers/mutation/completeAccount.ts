import { GraphQLError } from "graphql";
import { MutationCompleteAccountArgs, MutationResolvers } from "../../__generated__/graphql";
import { GraphQLContext } from "../../graphql/GraphQLContext";
import prisma from "../../prisma";
import { decrypt } from "../../services/cipher";
import sha256 from "../../services/sha-256";

export const completeAccountResolver: MutationResolvers["completeAccount"] = async (_, args, context) => {
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

  const existingDevices = await prisma.annonymousDevice.findMany({
    where: {
      userId: context.annonymousUserDevice.userId
    },
    include: {
      token: true
    }
  })

  const [completedUser] = await prisma.$transaction([
    prisma.user.create({
      include: {
        devices: true,
      },
      data: {
        username: username,
        email: email,
        hashedEmail: sha256(email),
        name: name,
        password: sha256(password),
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
          create: existingDevices.map(d => ({
            name: d.name,
            token: {
              create: d.token ? {
                token: d.token.token,
                platform: d.token.platform,
                env: d.token.env
              } : undefined
            }
          }))
        }
      }
    }),
    prisma.anonymousUser.delete({ where: { id: context.annonymousUserDevice.user.id } }),
  ])

  const newDevice = completedUser.devices.find(d => d.name === context.annonymousUserDevice!.name)!

  context.annonymousUserDevice = undefined
  context.userDevice = {
    ...newDevice,
    user: completedUser
  }

  return {
    completeAccount: {
      id: completedUser.id,
      username: username,
      followingCount: 0,
      followerCount: 0,
      name: completedUser.name,
      link: "https://cut.watch/p/" + username,
      share_url: "https://cut.watch/p/" + username,
    },
    updatedDevice: {
      name: completedUser.devices[0].name,
      session_id: completedUser.devices[0].sessionId
    }
  }
}

export default completeAccountResolver;
