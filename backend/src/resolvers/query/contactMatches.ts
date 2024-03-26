import { GraphQLError } from "graphql";
import { QueryResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";

const contactMatches: QueryResolvers["contactMatches"] = async (_, __, context) => {
  if (!context.userDevice) {
    throw new GraphQLError("Unauthorized ")
  }
  const userId = context.userDevice.userId

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
  })).then((users) => users.filter((user) => user.id !== userId))

  const emailContacts = prisma.emailContact.findMany({
    where: {
      userId: userId
    }
  }).then((contacts) => prisma.user.findMany({
    where: {
      OR: contacts.map((contact) => ({
        hashedEmail: contact.email
      }))
    }
  })).then((users) => users.filter((user) => user.id !== userId))

  const [phoneUsers, emailUsers] = await Promise.all([phoneContacts, emailContacts])
  const uniqueUsers = new Map([...phoneUsers, ...emailUsers].map((user) => [user.id, user]))
  return Array.from(uniqueUsers.values())
}

export default contactMatches
