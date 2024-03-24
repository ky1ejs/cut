//
//  ContactSyncer .swift
//  Cut
//
//  Created by Kyle Satti on 3/22/24.
//

import Contacts

struct ContactSyncer {
    enum ContactSyncerError: Error {
        case unknown
        case error(Error)
    }
    static func sync() async throws -> [CutGraphQL.ProfileFragment] {
        let result = await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                let keys: [CNKeyDescriptor] = [
                    CNContactIdentifierKey as NSString,
                    CNContactPhoneNumbersKey as NSString,
                    CNContactEmailAddressesKey as NSString,
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                ]
                let request = CNContactFetchRequest(keysToFetch: keys)
                var phoneNumbers = [CutGraphQL.ContactInput]()
                var emails = [CutGraphQL.ContactInput]()
                let formatter = CNContactFormatter()
                formatter.style = .fullName
                try? CNContactStore().enumerateContacts(with: request) { contact, _ in
                    let id = contact.identifier
                    guard let name = formatter.string(from: contact) else {
                        return
                    }
                    contact.phoneNumbers.forEach { p in
                        phoneNumbers.append(CutGraphQL.ContactInput(
                            name: name,
                            contactField: p.value.stringValue,
                            externalId: id)
                        )
                    }
                    contact.emailAddresses.forEach { e in
                        emails.append(CutGraphQL.ContactInput(
                            name: name,
                            contactField: e.value as String,
                            externalId: id)
                        )
                    }
                }
                continuation.resume(returning: (phoneNumbers, emails))
            }
        }

        async let numberUpload: () = uploadPhoneNumbers(result.0)
        async let emailUpload: () = uploadPhoneEmails(result.1)
        let _ = try await [numberUpload, emailUpload]

        return try await withCheckedThrowingContinuation { continuation in
            AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetContactMatchesQuery()) { result in
                switch result {
                case .success(let response):
                    if let profiles = response.data?.contactMatches.map({ c in
                        return c.fragments.profileFragment
                    }) {
                        continuation.resume(returning: profiles)
                    } else {
                        continuation.resume(throwing: ContactSyncerError.unknown)
                    }
                case .failure(let error):
                    continuation.resume(throwing: ContactSyncerError.error(error))
                }
            }
        }
    }

    private static func uploadPhoneNumbers(_ contacts: [CutGraphQL.ContactInput]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UploadContactNumbersMutation(contacts: contacts)) { result in
                switch result {
                case .success(let response):
                    if let error = response.errors?.first {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
        }
    }

    private static func uploadPhoneEmails(_ contacts: [CutGraphQL.ContactInput]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UploadContactEmailsMutation(contacts: contacts)) { result in
                switch result {
                case .success(let response):
                    if let error = response.errors?.first {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
        }
    }
}
