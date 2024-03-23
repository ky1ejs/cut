//
//  InitiateEmailConfirm.swift
//  Cut
//
//  Created by Kyle Satti on 3/2/24.
//

import SwiftUI
import Apollo

struct InitiateEmailConfirm: View {
    @State private var email = ""
    @State private var pushNextPage = false
    @State private var inFlightRequest: Apollo.Cancellable?
    @State private var error: Error?

    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 4) {
                Text("🎬")
                    .font(.system(size: 80))
                    .padding(.top, 48)
                Text("Make the Cut")
                    .font(.cut_title1)
                    .foregroundStyle(.black)
                    .padding(.top, 12)
                Text("complete your account")
                    .font(.cut_subheadline)
                    .foregroundStyle(.black)
                Text("Complete your Cut account to follow friends, access your data on another device and more.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 16)
                TextField(text: $email) {
                    Text("email")
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(CutTextFieldStyle())
                .padding(.top, 38)
                PrimaryButton(text: "Confirm Email", state: inFlightRequest == nil ? .notLoading : .loading) {
                    onEmailConfirm()
                }
                .padding(.top, 24)
                Spacer()
            }
            .padding(.horizontal, 28)
            .navigationDestination(isPresented: $pushNextPage) {
                CheckEmailVerification()
            }.errorAlert(error: $error, buttonTitle: "OK")
        }
    }

        func onEmailConfirm() {
            guard inFlightRequest == nil else {
                return
            }
            inFlightRequest = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.InitiateEmailVerificationQuery(email: email)) { result in
                inFlightRequest = nil
                switch result {
                case .success(let payload):
                    if let error = payload.errors?.first {
                        self.error = error
                    } else if payload.data!.initiateEmailVerification {
                        pushNextPage = true
                    }
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }

    #Preview {
        InitiateEmailConfirm()
    }

    extension View {
        func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
            let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
            return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
                Button(buttonTitle) {
                    error.wrappedValue = nil
                }
            } message: { error in
                Text(error.recoverySuggestion ?? "")
            }
        }
    }

    struct LocalizedAlertError: LocalizedError {
        let underlyingError: LocalizedError
        var errorDescription: String? {
            underlyingError.errorDescription
        }
        var recoverySuggestion: String? {
            underlyingError.recoverySuggestion
        }

        init?(error: Error?) {
            guard let localizedError = error as? LocalizedError else { return nil }
            underlyingError = localizedError
        }
    }
