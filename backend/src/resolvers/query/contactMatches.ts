import { GraphQLError } from "graphql";
import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const contactMatches: QueryResolvers["contactMatches"] = async (_, __, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized ")
  }

  const phoneContacts = prisma.phoneContact.findMany({
    where: {
      userId: context.userDevice.userId
    }
  }).then((contacts) => prisma.user.findMany({
    where: {
      OR: contacts.map((contact) => ({
        hashedPhoneNumber: contact.phoneNumber
      }))
    }
  }))

  const emailContacts = prisma.emailContact.findMany({
    where: {
      userId: context.userDevice.userId
    }
  }).then((contacts) => prisma.user.findMany({
    where: {
      OR: contacts.map((contact) => ({
        hashedEmail: contact.email
      }))
    }
  }))

  const [phoneUsers, emailUsers] = await Promise.all([phoneContacts, emailContacts])

  const users = new Set([...phoneUsers, ...emailUsers])

  return Array.from(users.values())
}

export default contactMatches
