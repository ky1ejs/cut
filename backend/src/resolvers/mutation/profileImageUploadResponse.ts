import { MutationResolvers } from "../../__generated__/graphql"
import prisma from "../../prisma"
import dbUserToGqlUser from "../mappers/dbUserToGqlUser"
import uploadcare, { UploadcareSimpleAuthSchema } from '@uploadcare/rest-client'

const profileImageUploadResponse: MutationResolvers["profileImageUploadResponse"] = async (parent, args, context) => {
  console.log(`args.response: ${args.response}`)
  if (!context.userDevice) {
    throw new Error('Unauthorized')
  }

  if (!process.env.UPLOADCARE_PUBLIC_KEY || !process.env.UPLOADCARE_SECRET_KEY) {
    throw new Error('Uploadcare keys not set')
  }

  const uploadcareSimpleAuthSchema = new UploadcareSimpleAuthSchema({
    publicKey: process.env.UPLOADCARE_PUBLIC_KEY,
    secretKey: process.env.UPLOADCARE_SECRET_KEY
  })

  if (context.userDevice.user.imageId) {
    await uploadcare.deleteFile({ uuid: context.userDevice.user.imageId }, { authSchema: uploadcareSimpleAuthSchema })
  }
  const imageId = JSON.parse(args.response).file
  console.log(`imageId: ${imageId}`)
  await uploadcare.storeFile({ uuid: imageId }, { authSchema: uploadcareSimpleAuthSchema })
  const user = await prisma.user.update({
    where: { id: context.userDevice.user.id },
    data: { imageId }
  })
  console.log(`updated image: ${user.imageId}`)
  return dbUserToGqlUser(user)
}
export default profileImageUploadResponse;
