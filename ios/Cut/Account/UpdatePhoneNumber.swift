//
//  UpdatePhoneNumber.swift
//  Cut
//
//  Created by Kyle Satti on 6/23/24.
//

import SwiftUI
import Apollo

struct UpdatePhoneNumber: View {
    @State var phoneNumber = ""
    @State var inFlightRequest: Apollo.Cancellable?
    @Environment(\.onboardingCompletion) var onboardingCompletion
    @State var error: Error?

    var body: some View {
        VStack(spacing: 48) {
            VStack(spacing: 12) {
                Text("Help your friends find you")
                    .font(.cut_title1)
                    .bold()
                Text("Add your phone number so your friends can easily find and follow you.")
                    .multilineTextAlignment(.center)
            }
            TextField(text: $phoneNumber, label: {
                Text(verbatim: "+1 123 123 123")
            })
            .textFieldStyle(CutTextFieldStyle())
            .keyboardType(.phonePad)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .disabled(inFlightRequest != nil)
            .onSubmit {
                submit()
            }
            VStack {
                PrimaryButton("Submit", isLoading: inFlightRequest != nil) {
                    submit()
                }
                .disabled(phoneNumber.isEmpty)
                TertiaryButton("Skip") {
                    onboardingCompletion()
                }
                .disabled(inFlightRequest != nil)
            }
        }
        .padding(.horizontal, 18)
        .errorAlert(error: $error)
    }

    func submit() {
        guard inFlightRequest == nil else { return }
        guard !phoneNumber.isEmpty else { return }
        inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.UpdateAccountMutation(params: CutGraphQL.UpdateAccountInput(phoneNumber: .some(phoneNumber)))) { result in
            switch result.parseGraphQL() {
            case .success:
                onboardingCompletion()
            case .failure(let error):
                self.error = error
            }
        }
    }
}

#Preview {
    UpdatePhoneNumber()
}
