import { PhoneNumberUtil } from "google-libphonenumber"
import sha256 from "./sha-256"

type ProcessedPhoneNumber = { code?: string, hashedPhoneNumber: string, phoneNumber: string }

export default function processPhoneNumber(phoneNumber: string): ProcessedPhoneNumber {
  let phoneUtil = PhoneNumberUtil.getInstance()
  const cleanedPhoneNumber = phoneNumber.replace(/[^\d\+]+/g, '').replace(/(.)\++/g, "$1")
  try {
    // create a clean phone number by replace with regex that filters out anthing that's not a digit or a plus sign
    const parsed = phoneUtil.parse(cleanedPhoneNumber)
    const extractedPhoneNumber = parsed.getNationalNumberOrDefault().toString()
    const hashedPhoneNumber = sha256(extractedPhoneNumber)
    const code = parsed.getCountryCodeOrDefault().toString()
    return { code, hashedPhoneNumber, phoneNumber: extractedPhoneNumber }
  } catch (e) {
    const hashedPhoneNumber = sha256(cleanedPhoneNumber)
    return { code: undefined, hashedPhoneNumber, phoneNumber: cleanedPhoneNumber }
  }
}