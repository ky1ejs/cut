//
//  CompleteAccountForm.swift
//  Cut
//
//  Created by Kyle Satti on 2/27/24.
//

import SwiftUI
import Apollo
import Combine

class Debouncer {
    var timer: Timer?
    let delay: TimeInterval

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func debounce(_ closure: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            closure()
        }
    }
}


@Observable
class CompleteAccountFormViewModel {
    var username = "" {
        didSet {
            debouncer.debounce {
                self.updateUsernameAvailability()
            }
        }
    }
    var name = ""
    var password = ""
    var usernameState = UsernameAvailabilityIndicator.State.empty
    private var usernameCheck: Apollo.Cancellable?
    private var checkCancelable: AnyCancellable?
    private let debouncer = Debouncer(delay: 0.2)

    func updateUsernameAvailability() {
        print(username)
        self.usernameCheck?.cancel()
        guard username.count > 0 else {
            self.usernameState = .empty
            return
        }
        guard username.count > 1 else {
            self.usernameState = .error
            return
        }
        self.usernameState = .loading
        self.usernameCheck = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.CheckUsernameAvailabilityQuery(username: username), resultHandler: { result in
            guard let isAvailable = try? result.get().data?.isUsernameAvailable else {
                self.usernameState = .error
                return
            }
            print("parsed")
            self.usernameState = isAvailable ? .available : .unavailable
        })
    }
}

struct CompleteAccountForm: View {
    let emailVerificationToken: String
    @State private var viewModel = CompleteAccountFormViewModel()
    @EnvironmentObject private var controller: AccountCompletionController
    @State private var inFlightRequest: Apollo.Cancellable?
    @State private var error: Error?

    var body: some View {
        ZStack {
            Color.cutOrange.ignoresSafeArea()
            VStack(alignment: .center, spacing: 4) {
                Text("🎬")
                    .font(.system(size: 80))
                    .padding(.top, 48)
                Text("Make the Cut")
                    .font(.cut_title1)
                    .foregroundStyle(.white)
                    .padding(.top, 12)
                Text("Complete your account")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Text("Last step, set your username and password.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 16)
                HStack(spacing: 0) {
                    TextField(text: $viewModel.username) {
                        Text("username")
                    }
                    UsernameAvailabilityIndicator(state: viewModel.usernameState).padding(.horizontal, 8)
                }
                .textFieldStyle(CutTextFieldStyle())
                .padding(.top, 12)
                TextField(text: $viewModel.name) {
                    Text("name")
                }
                .textFieldStyle(CutTextFieldStyle())
                .padding(.top, 12)
                SecureField(text: $viewModel.password) {
                    Text("password")
                }.textFieldStyle(CutTextFieldStyle())
                    .padding(.top, 12)
                CutButton(action: {
                    completeAccount()
                }, text: "Complete Account", state: inFlightRequest == nil ? .notLoading : .loading)
                Spacer()
            }
            .frame(maxWidth: 300)
            .errorAlert(error: $error)
        }
    }

    func completeAccount() {
        let input = CutGraphQL.CompleteAccountInput(
            username: viewModel.username,
            name: viewModel.name,
            password: viewModel.password,
            emailToken: emailVerificationToken
        )
        inFlightRequest = SessionManager.shared.completeAccount(input) { result in
            inFlightRequest = nil
            switch result {
            case .success:
                controller.isFinished = true
            case .failure(let error):
                self.error = error
            }
        }
    }
}

struct CutTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
            .padding(.vertical, 10)
            .padding(.horizontal, 6)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .foregroundColor(.black)
        }
}

#Preview {
    CompleteAccountForm(emailVerificationToken: "")
}
