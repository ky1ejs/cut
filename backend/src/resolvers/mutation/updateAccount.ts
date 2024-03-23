import { GraphQLError } from "graphql";
import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { Prisma } from "@prisma/client";
import { hash } from "../../services/bcrypt";
import processPhoneNumber from "../../services/phoneNumberProcessing";

const updateAccount: MutationResolvers["updateAccount"] = async (_, args, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized")
  }

  const params = args.params
  let update: Prisma.UserUpdateInput = {}

  if (params.username) {
    update.username = params.username
  }

  if (params.name) {
    update.name = params.name
  }

  if (params.password) {
    update.password = await hash(params.password)
  }

  if (params.bio !== undefined) {
    update.bio = params.bio
  }

  if (params.phoneNumber !== undefined) {
    if (params.phoneNumber === null) {
      update.phoneNumber = null
      update.countryCode = null
      update.hashedPhoneNumber = null
    } else {
      const processedPhoneNumber = await processPhoneNumber(params.phoneNumber)
      update.phoneNumber = processedPhoneNumber.phoneNumber
      update.countryCode = processedPhoneNumber.code
      update.hashedPhoneNumber = processedPhoneNumber.hashedPhoneNumber
    }
  }

  if (params.url !== undefined) {
    update.url = params.url
  }

  const updatedUser = await prisma.user.update({
    where: { id: context.userDevice.userId },
    data: update
  })

  return {
    ...updatedUser,
    phoneNumber: updatedUser.phoneNumber ? `${updatedUser.countryCode}${updatedUser.phoneNumber}` : null
  }
}

export default updateAccount;