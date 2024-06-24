import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { sendEmail } from "../../services/send-email";

const initiateAuthentication: MutationResolvers["initiateAuthentication"] = async (_, args, context) => {
  // validate email
  const emailRegex = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/
  if (!emailRegex.test(args.email)) {
    throw new Error("Invalid email")
  }

  // create 4 digit code
  const code = Math.floor(1000 + Math.random() * 9000)

  const existingRequest = await prisma.autheticationRequest.findUnique({
    where: {
      email: args.email
    }
  })

  if (existingRequest) {
    const twentyNineSecondsInMillis = 1000 * 29
    if (existingRequest.createdAt.valueOf() + twentyNineSecondsInMillis > new Date().valueOf()) {
      throw new Error("Email recently sent, please wait 30 seconds before trying again")
    } else {
      await prisma.autheticationRequest.delete({
        where: {
          email: args.email
        }
      })
    }
  }

  const request = await prisma.autheticationRequest.create({
    data: {
      email: args.email,
      code: code.toString(),
      createdAt: new Date()
    }
  })

  // create link for mobile to parse or web fallback
  const url = `https://cut.watch/verify-email?code=${code}`
  const content = `
    <div>
      <p>Click the link to confirm your email</p>
      <a href="${url}">Verify Email</a>
      <p>Or enter the code: ${code}</p>
    </div>
  `

  // send email
  await sendEmail(args.email, "Verify Email", content)

  return request.id
}

export default initiateAuthentication
