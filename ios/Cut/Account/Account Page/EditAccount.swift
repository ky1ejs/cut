//
//  EditAccount.swift
//  Cut
//
//  Created by Kyle Satti on 3/22/24.
//

import SwiftUI
import Apollo

struct EditAccount: View {
    let user: CutGraphQL.CompleteAccountFragment
    let onCompletion: (() -> Void)?

    @State private var username: String
    @State private var name: String
    @State private var bio: String
    @State private var url: String
    @State private var phoneNumber: String
    @State private var inFlightRequest: Apollo.Cancellable?
    @State private var error: Error?

    init(user: CutGraphQL.CompleteAccountFragment, onCompletion: (() -> Void)? = nil) {
        self.user = user
        self.onCompletion = onCompletion
        username = user.username
        name = user.name
        bio = user.bio ?? ""
        url = user.url ?? ""
        phoneNumber = user.phoneNumber ?? ""
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                HStack {
                    Button("Cancel") {
                        onCompletion?()
                    }
                    Spacer()
                    Text("Edit your account").font(.cut_title3)
                    Spacer()
                    Button(action: {
                        updateAccount()
                    }, label: {
                        if inFlightRequest == nil {
                            Text("Save")
                        } else {
                            ProgressView()
                        }
                    })
                }.padding(.bottom, 32)
                CutTextField(text: $username, label: "Username") {
                    UsernameAvailabilityIndicator(state: .empty)
                }
                CutTextField(text: $name, label: "Name")
                CutTextField(text: $bio, label: "Bio")
                CutTextField(text: $url, label: "Url")
                CutTextField(text: $phoneNumber, label: "Phone Number")
            }
            .padding(.horizontal, 18)
            .padding(.top, 32)
            .disabled(inFlightRequest != nil)
        }
        .scrollBounceBehavior(.basedOnSize)
        .errorAlert(error: $error)
    }

    private func updateAccount() {
        guard inFlightRequest == nil else { return }
        inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UpdateAccountMutation(params: CutGraphQL.UpdateAccountInput(
            username: .some(username),
            phoneNumber: .some(phoneNumber),
            name: .some(name),
            bio: .some(bio),
            url: .some(url))
        ), resultHandler: { result in
            switch result.parseGraphQL() {
            case .success:
                inFlightRequest = nil
                onCompletion?()
            case .failure(let error):
                self.error = error
            }
        })
    }
}

#Preview {
    EditAccount(user: Mocks.completeAccount)
}

#Preview {
    Profile(profile: .loggedInUser(Mocks.completeAccount))
}
