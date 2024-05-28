//
//  CompleteAccountForm.swift
//  Cut
//
//  Created by Kyle Satti on 2/27/24.
//

import SwiftUI
import Apollo
import Combine
import Contacts

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
    var usernameState = UsernameAvailabilityIndicator.ViewState.empty
    var bio = ""
    var profileImageId = ""
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
        self.usernameCheck = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.CheckUsernameAvailabilityQuery(username: username), resultHandler: { result in
            guard let isAvailable = try? result.get().data?.isUsernameAvailable else {
                self.usernameState = .error
                return
            }
            self.usernameState = isAvailable ? .available : .unavailable
        })
    }
}

struct CompleteAccountForm: View {
    @Environment(\.theme) var theme
    let email: String
    let authId: String
    let code: String
    @State var pushNextStep = false
    @State private var viewModel = CompleteAccountFormViewModel()
    @State private var inFlightRequest: Apollo.Cancellable?
    @State private var error: Error?

    var body: some View {
        VStack(alignment: .center, spacing: 42) {
            ZStack {
                VStack {
                    Grid {
                        ForEach(0..<2, id: \.self) { _ in
                            GridRow {
                                ForEach(0..<4, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .containerRelativeFrame(.horizontal) { s, _ in
                                            0.20 * s
                                        }
                                        .aspectRatio(0.66, contentMode: .fit)
                                        .foregroundColor(theme.extraLightGray.color)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                .offset(y: -150)
                .overlay {
                    LinearGradient(
                        gradient:
                            Gradient(colors: [.clear, theme.background.color]),
                        startPoint: .init(x: 0.5, y: 0),
                        endPoint: .init(x: 0.5, y: 0.13))
                    .fixedSize(horizontal: false, vertical: false)
                    .ignoresSafeArea()
                }
                VStack(spacing: 24) {
                    VStack {
                        Image("avatar_placeholder")
                            .frame(width: 88, height: 88)
                            .overlay {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background {
                                                Circle()
                                                    .foregroundStyle(.black)
                                            }
                                            .offset(x: 4, y: 4)
                                    }
                                }
                            }
                        Text("Your Profile")
                            .font(.cut_title1)
                    }
                    VStack(alignment: .leading) {
                        Text("Name & username")
                            .font(.cut_subheadline)
                        VStack() {
                            CutTextField(text: $viewModel.username, placeholder: "username") {
                                UsernameAvailabilityIndicator(state: viewModel.usernameState)
                                    .padding(.horizontal, 8)
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            CutTextField(text: $viewModel.name, placeholder: "name")
                                .autocorrectionDisabled()

                        }.disabled(inFlightRequest != nil)
                    }
                    VStack(alignment: .leading) {
                        Text("Your bio")
                            .font(.cut_subheadline)
                        VStack(spacing: 16) {
                            TextField(
                                "",
                                text: $viewModel.bio,
                                prompt:
                                    Text("...about you")
                                    .foregroundStyle(theme.textFieldPlaceholderColor.color), axis: .vertical
                            )
                            .textFieldStyle(CutTextFieldStyle())
                            .lineLimit(3...5)
                        }.disabled(inFlightRequest != nil)
                    }
                    PrimaryButton("Complete Account", isLoading: inFlightRequest != nil) {
                        completeAccount()
                    }
                    Spacer()
                }
                .padding(.top, 48)
                .padding(.horizontal, 24)
                .errorAlert(error: $error)
            }
        }
        .navigationDestination(isPresented: $pushNextStep) {
            FindFriends()
        }
    }

    func completeAccount() {
        let input = CutGraphQL.CompleteAccountInput(
            username: viewModel.username,
            name: viewModel.name,
            email: email,
            profileImageId: viewModel.profileImageId.count > 0 ? .some(viewModel.profileImageId) : .null,
            bio: viewModel.bio.count > 0 ? .some(viewModel.bio) : .null,
            code: code,
            authenticationId: authId,
            deviceName: UIDevice.current.name
        )
        inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.CompleteAccountMutation(params: input)) { result in
            switch result.parseGraphQL() {
            case .success(let data):
                let account = data.completeAccount.completeAccount.fragments.completeAccountFragment
                let sessionId = data.completeAccount.updatedDevice.session_id
                do {
                    try SessionManager.shared.userLoggedIn(account: account, sessionId: sessionId)
                    pushNextStep = true
                } catch {
                    self.error = error
                }
            case .failure(let error):
                self.error = error
            }
            inFlightRequest = nil
        }
    }
}

#Preview {
    CompleteAccountForm(
        email: "",
        authId: "",
        code: ""
    )
}
