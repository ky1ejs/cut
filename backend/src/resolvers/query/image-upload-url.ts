import { generateSecureSignature } from '@uploadcare/signed-uploads'
import { QueryResolvers } from '../../__generated__/graphql'

const imageUploadUrl: QueryResolvers["imageUploadUrl"] = (_, __, context) => {
  if (!context.userDevice) throw new Error('Unauthorized')
  const publicKey = process.env.UPLOADCARE_PUBLIC_KEY
  const secret = process.env.UPLOADCARE_SECRET_KEY
  if (!publicKey || !secret) throw new Error('keys are not set')
  const { secureSignature, secureExpire } = generateSecureSignature(secret, {
    lifetime: 60 * 30 * 1000 // expire in 30 minutes
  })
  return {
    url: `https://upload.uploadcare.com/base/`,
    fileName: context.userDevice.user.id,
    headers: [
      { key: 'signature', value: secureSignature },
      { key: 'expire', value: secureExpire },
      { key: 'UPLOADCARE_PUB_KEY', value: publicKey },
    ]
  }
}

export default imageUploadUrl
