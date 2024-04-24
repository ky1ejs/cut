//
//  ContactSyncer .swift
//  Cut
//
//  Created by Kyle Satti on 3/22/24.
//

import Contacts

struct ContactSyncer {
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
            AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetContactMatchesQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    let profiles = data.contactMatches.map { $0.fragments.profileFragment }
                    continuation.resume(returning: profiles)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private static func uploadPhoneNumbers(_ contacts: [CutGraphQL.ContactInput]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UploadContactNumbersMutation(contacts: contacts)) { result in
                switch result.parseGraphQL() {
                case .success:
                    continuation.resume()
                case .failure(let error): 
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private static func uploadPhoneEmails(_ contacts: [CutGraphQL.ContactInput]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UploadContactEmailsMutation(contacts: contacts)) { result in
                switch result.parseGraphQL() {
                case .success:
                    continuation.resume()
                case .failure(let error): 
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
