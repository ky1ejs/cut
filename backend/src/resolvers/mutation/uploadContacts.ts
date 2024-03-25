import { ContactInput, MutationResolvers } from "../../__generated__/graphql";
import prisma from "../../prisma";
import { GraphQLError } from "graphql";
import processPhoneNumber from "../../services/phoneNumberProcessing";
import sha256 from "../../services/sha-256";
import { Prisma } from "@prisma/client";

export const uploadContactNumbers: MutationResolvers["uploadContactNumbers"] = async (_, { contacts }, context) => {
  if (!context.userDevice) {
    throw new GraphQLError('Not authenticated')
  }
  const { userDevice: { userId } } = context

  const processedContacts = contacts
    .map((input) => {
      const proccessedPhoneNubmer = processPhoneNumber(input.contactField)
      return {
        ...input,
        code: proccessedPhoneNubmer.code,
        contactField: proccessedPhoneNubmer.hashedPhoneNumber
      }
    })

  // remove duplicate contactFields
  const uniqueContacts = Array.from(new Map(processedContacts.map((contact) => [`${contact.contactField}:${contact.externalId}`, contact])).values())

  const existingRecords = await prisma.phoneContact.findMany({
    where: {
      userId,
      externalId: {
        in: uniqueContacts.map((contact) => contact.externalId)
      }
    }
  })
  // existing records array to map
  const existingRecordsMap = new Map(existingRecords.map((record) => [`${record.phoneNumber}:${record.externalId}`, record]))
  let newContacts = []
  let updatedContacts = []
  for (const contact of uniqueContacts) {
    const existingRecord = existingRecordsMap.get(`${contact.contactField}:${contact.externalId}`)
    if (existingRecord) {
      updatedContacts.push({ ...contact, id: existingRecord.id })
    } else {
      newContacts.push(contact)
    }
  }
  const deletedContacts = existingRecords
    .filter((record) => !uniqueContacts.some((contact) => contact.externalId === record.externalId))

  let promises = []
  if (newContacts.length > 0) {
    promises.push(prisma.phoneContact.createMany({
      data: newContacts.map((contact) => ({
        countryCode: contact.code,
        phoneNumber: contact.contactField,
        name: contact.name,
        externalId: contact.externalId,
        userId
      }))
    }))
  }
  if (updatedContacts.length > 0) {
    for (const contact of updatedContacts) {
      promises.push(prisma.phoneContact.update({
        where: { id: contact.id },
        data: {
          countryCode: contact.code,
          phoneNumber: contact.contactField,
          name: contact.name
        }
      }))
    }
  }
  if (deletedContacts.length > 0) {
    promises.push(prisma.phoneContact.deleteMany({
      where: {
        userId,
        externalId: {
          in: deletedContacts.map((contact) => contact.externalId)
        }
      }
    }))
  }

  await Promise.all(promises)

  return true
}

export const uploadContactEmails: MutationResolvers["uploadContactEmails"] = async (_, { contacts }, context) => {
  if (!context.userDevice) throw new GraphQLError('Not authenticated')
  const { userDevice: { userId } } = context
  const hashedEmails = contacts.map((contact) => ({ ...contact, contactField: sha256(contact.contactField.toLowerCase()) }))
  const uniqueEmails = Array.from(new Map(hashedEmails.map((contact) => [`${contact.contactField}:${contact.externalId}`, contact])).values())
  const existingRecords = await prisma.emailContact.findMany({
    where: {
      userId,
      externalId: {
        in: uniqueEmails.map((contact) => contact.externalId)
      }
    }
  })
  const existingRecordsMap = new Map(existingRecords.map((record) => [`${record.email}:${record.externalId}`, record]))
  let newContacts = []
  let updatedContacts = []
  for (const contact of uniqueEmails) {
    const existingRecord = existingRecordsMap.get(`${contact.contactField}:${contact.externalId}`)
    if (existingRecord) {
      updatedContacts.push({ ...contact, id: existingRecord.id })
    } else {
      newContacts.push(contact)
    }
  }
  const deletedContacts = existingRecords
    .filter((record) => !uniqueEmails.some((contact) => contact.externalId === record.externalId))
  let promises = []

  if (newContacts.length > 0) {
    promises.push(prisma.emailContact.createMany({
      data: newContacts.map((contact) => ({
        name: contact.name,
        externalId: contact.externalId,
        email: contact.contactField,
        userId
      }))
    }))
  }
  if (updatedContacts.length > 0) {
    for (const contact of updatedContacts) {
      promises.push(prisma.emailContact.update({
        where: { id: contact.id },
        data: {
          name: contact.name,
          email: contact.contactField
        }
      }))
    }
  }
  if (deletedContacts.length > 0) {
    promises.push(prisma.emailContact.deleteMany({
      where: {
        userId,
        externalId: {
          in: deletedContacts.map((contact) => contact.externalId)
        }
      }
    }))
  }

  await Promise.all(promises)

  return true
}
