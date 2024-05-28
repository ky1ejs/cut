import { User } from "@prisma/client";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { mapProfile } from "../mappers/profileMapper";

export async function validateAuth(id: string, code: string): Promise<User | undefined> {
  const request = await prisma.autheticationRequest.findUnique({ where: { id } })

  if (!request) {
    throw new Error("Invalid request")
  }

  if (request.code !== code) {
    throw new Error("Invalid code")
  }

  const account = await prisma.user.findUnique({
    where: {
      email: request.email
    }
  })

  return account ?? undefined
}

const validateAuthentication: MutationResolvers["validateAuthentication"] = async (_, args, context) => {
  const account = await validateAuth(args.id, args.code)

  if (account) {
    await prisma.autheticationRequest.delete({
      where: {
        id: args.id
      }
    })
    let device = await prisma.device.create({
      data: {
        name: args.deviceName,
        user: {
          connect: {
            id: account.id
          }
        }
      }
    })
    return {
      __typename: "CompleteAccountResult",
      completeAccount: {
        ...mapProfile(account, undefined, undefined),
        __typename: "CompleteAccount",
        isCurrentUser: false
      },
      updatedDevice: {
        name: device.name,
        session_id: device.sessionId
      }
    }
  } {
    return {
      __typename: "EmptyResponse",
      success: true
    }
  }
}

export default validateAuthentication;
