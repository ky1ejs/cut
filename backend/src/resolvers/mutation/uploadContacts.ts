import { MutationResolvers } from "../../__generated__/graphql";
import { PhoneNumberUtil } from 'google-libphonenumber';
import prisma from "../../prisma";
import { GraphQLError } from "graphql";
import { hash } from '../../services/bcrypt'
import processPhoneNumber from "../../services/phoneNumberProcessing";

export const uploadContactNumbers: MutationResolvers["uploadContactNumbers"] = async (_, { contacts }, context) => {
  if (!context.userDevice) {
    throw new GraphQLError('Not authenticated')
  }
  const { userDevice: { userId } } = context

  const processedContactsPromise = contacts
    .map(async (input) => {
      const proccessedPhoneNubmer = await processPhoneNumber(input.contactField)
      return { ...input, code: proccessedPhoneNubmer.code, contactField: proccessedPhoneNubmer.hashedPhoneNumber }
    })
  const processedContacts = await Promise.all(processedContactsPromise)
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
  const hashedEmailsPromise = contacts.map(async (contact) => ({ ...contact, contactField: await hash(contact.contactField.toLowerCase()) }))
  const hashedEmails = await Promise.all(hashedEmailsPromise)
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