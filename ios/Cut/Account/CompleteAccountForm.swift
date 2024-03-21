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
            usernameState = .loading
            debouncer.debounce {
                self.updateUsernameAvailability()
            }
        }
    }
    var name = ""
    var password = ""
    var usernameState = UsernameAvailabilityIndicator.ViewState.empty
    private var usernameCheck: Apollo.Cancellable?
    private var checkCancelable: AnyCancellable?
    private let debouncer = Debouncer(delay: 0.2)

    func updateUsernameAvailability() {
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
        VStack(alignment: .center, spacing: 42) {
            Text("Complete your account")
                .font(.cut_title1)
                .padding(.top, 42)
            VStack(spacing: 16) {
                CutTextField(text: $viewModel.username, label: "Username") {
                    UsernameAvailabilityIndicator(state: viewModel.usernameState)
                        .padding(.horizontal, 8)
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                CutTextField(text: $viewModel.name, label: "Name")
                    .autocorrectionDisabled()
                CutTextField(
                    text: $viewModel.password,
                    label: "Password",
                    secure: true
                )

            }.disabled(inFlightRequest != nil)
            PrimaryButton(text: "Complete Account", state: inFlightRequest == nil ? .notLoading : .loading) {
                completeAccount()
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .errorAlert(error: $error)
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

struct CutTextField<Accessory>: View where Accessory : View {
    @Binding var text: String
    let label: String
    let secure: Bool
    @ViewBuilder let accessoryView: (() -> Accessory)?

    init(text: Binding<String>, label: String, secure: Bool = false, accessoryView: @escaping (() -> Accessory)) {
        self._text = text
        self.label = label
        self.secure = secure
        self.accessoryView = accessoryView
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.cut_footnote)
            HStack {
                if secure {
                    SecureField(text: $text) {
                        Text(label.lowercased())
                    }
                } else {
                    TextField(text: $text) {
                        Text(label.lowercased())
                    }
                }
                accessoryView?()
            }
        }.textFieldStyle(CutTextFieldStyle())
    }
}

extension CutTextField where Accessory == EmptyView {
    init(text: Binding<String>, label: String, secure: Bool = false) {
        self._text = text
        self.label = label
        self.secure = secure
        self.accessoryView = nil
    }
}

struct CutTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) private var colorScheme

    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background((RoundedRectangle(cornerRadius: 6).strokeBorder(.gray)))
    }
}

#Preview {
    CompleteAccountForm(emailVerificationToken: "")
}
