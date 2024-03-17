import { GraphQLError } from "graphql";
import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { encrypt } from "../../services/cipher";
import { sendEmail } from "../../services/send-email";

const initiateEmailVerification: QueryResolvers["initiateEmailVerification"] = async (_, args, context) => {
  if (!context.annonymousUserDevice) {
    throw new GraphQLError("Unauthorized")
  }

  if (context.userDevice) {
    throw new GraphQLError("Account is already complete")
  }

  // validate email
  const emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,})+$/
  if (!emailRegex.test(args.email)) {
    throw new Error("Invalid email")
  }

  // check if email is already in use
  const existingUser = await prisma.user.findUnique({ where: { email: args.email } })
  if (existingUser) {
    throw new Error("Email already in use")
  }

  // create token
  const email = args.email
  const time = Date.now()
  const token = `${email}#${time}`

  // encrypt token
  const encryptedToken = encrypt(token, process.env.EMAIL_ENCRYPTION_KEY)

  // create link for mobile to parse or web fallback
  const url = `https://cut.watch/verify-email?token=${encryptedToken}`
  const content = `
    <div>
      <p>Click the link to confirm your email</p>
      <a href="${url}">Verify Email</a>
    </div>
  `

  // send email
  await sendEmail(email, "Verify Email", content)

  return true
}

export default initiateEmailVerification
