import { GraphQLError } from "graphql"
import { MutationResolvers } from "../../__generated__/graphql"
import { decrypt, encrypt } from "../../services/cipher"
import prisma from "../../prisma"

export const generateDeleteAccountCode: MutationResolvers["generateDeleteAccountCode"] = (_, __, context) => {
  let userId: string
  if (context.annonymousUserDevice) {
    userId = context.annonymousUserDevice.user.id
  } else if (context.userDevice) {
    userId = context.userDevice.user.id
  } else {
    throw new GraphQLError("Unauthorized")
  }

  const dateString = new Date().getTime().toString()
  const codeString = `${dateString}:${userId}`
  const code = encrypt(codeString, process.env.DELETE_ACCOUNT_ENCRYPTION_KEY)
  return code
}

export const deleteAccount: MutationResolvers["deleteAccount"] = async (_, args, context) => {
  const decoded = decrypt(args.code, process.env.DELETE_ACCOUNT_ENCRYPTION_KEY)
  console.log("decoded", decoded)
  const [dateString, userId] = decoded.split(":")
  if (!dateString || !userId) {
    throw new GraphQLError("Invalid code")
  }
  const date = new Date(parseInt(dateString))
  if (Date.now() - date.getTime() > 1000 * 60 * 15) {
    throw new GraphQLError("Code expired")
  }
  if (context.userDevice && context.userDevice.user.id === userId) {
    await prisma.user.delete({
      where: { id: userId }
    })
  } else if (context.annonymousUserDevice && context.annonymousUserDevice.user.id === userId) {
    await prisma.anonymousUser.delete({
      where: { id: userId }
    })
  } else {
    throw new GraphQLError("Unauthorized")
  }
  return true
}

