import { MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";
import processPhoneNumber from "../../services/phoneNumberProcessing";
import sha256 from "../../services/sha-256";

export const uploadContactNumbers: MutationResolvers["uploadContactNumbers"] = async (_, { contacts }, context) => {
  if (!context.userDevice) {
    throw new GraphQLError('Not authenticated')
  }
  const { userDevice: { userId } } = context

  const processedContacts = contacts
    .map((input) => {
      const proccessedPhoneNubmer = processPhoneNumber(input.contactField)
      return { ...input, code: proccessedPhoneNubmer.code, contactField: proccessedPhoneNubmer.hashedPhoneNumber }
    })
  await prisma.phoneContact.createMany({
    data: processedContacts.map((contact) => ({
      countryCode: contact.code,
      phoneNumber: contact.contactField,
      name: contact.name,
      externalId: contact.externalId,
      userId
    }))
  })
  return true
}

export const uploadContactEmails: MutationResolvers["uploadContactEmails"] = async (_, { contacts }, context) => {
  if (!context.userDevice) throw new GraphQLError('Not authenticated')
  const { userDevice: { userId } } = context
  const hashedEmails = contacts.map((contact) => ({ ...contact, contactField: sha256(contact.contactField.toLowerCase()) }))
  await prisma.emailContact.createMany({
    data: hashedEmails.map((contact) => ({
      name: contact.name,
      externalId: contact.externalId,
      email: contact.contactField,
      userId
    }))
  })
  return true
}
