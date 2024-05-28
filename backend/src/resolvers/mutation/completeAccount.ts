import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import sha256 from "../../services/sha-256";
import { validateAuth } from "./validateAuthentication";
import { WatchList } from "@prisma/client";
import { mapProfile } from "../mappers/profileMapper";

export const completeAccountResolver: MutationResolvers["completeAccount"] = async (_, args, context) => {
  const params = args.params

  if (context.userDevice) {
    throw new Error("User is already complete")
  }

  const account = await validateAuth(params.authenticationId, params.code)

  if (account) {
    throw new GraphQLError("User is already complete")
  }

  const userExists = await prisma.user.findFirst({
    where: {
      OR: [
        { email: params.email },
        { username: params.username }
      ]
    }
  })

  if (userExists) {
    throw new GraphQLError("Username taken")
  }

  let existingWatchList: WatchList[] = []
  if (context.annonymousUserDevice) {
    existingWatchList = await prisma.annonymousWatchList.findMany({
      where: { userId: context.annonymousUserDevice.user.id }
    })
  }

  const user =
    await prisma.user.create({
      include: {
        devices: true,
      },
      data: {
        username: params.username,
        email: params.email,
        hashedEmail: sha256(params.email),
        name: params.name,
        createdAt: context.annonymousUserDevice?.user.createdAt ?? new Date(),
        watchList: {
          createMany: {
            data: existingWatchList.map(w => ({
              movieId: w.movieId,
              createdAt: w.createdAt
            })),
            skipDuplicates: false
          }
        },
      }
    })

  if (context.annonymousUserDevice) {
    await prisma.anonymousUser.delete({
      where: {
        id: context.annonymousUserDevice.user.id
      }
    })
  }

  const newDevice = await prisma.device.create({
    data: {
      name: params.deviceName,
      user: {
        connect: {
          id: user.id
        }
      }
    }
  })

  context.annonymousUserDevice = undefined
  context.userDevice = {
    ...newDevice,
    user: user
  }

  return {
    completeAccount: {
      ...mapProfile(user, undefined, undefined),
      __typename: "CompleteAccount",
      isCurrentUser: true
    },
    updatedDevice: {
      name: newDevice.name,
      session_id: newDevice.sessionId
    }
  }
}

export default completeAccountResolver;
