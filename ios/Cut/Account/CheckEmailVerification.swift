//
//  CheckEmailVerification.swift
//  Cut
//
//  Created by Kyle Satti on 3/2/24.
//

import SwiftUI
import Apollo
struct CheckEmailVerification: View {
    let email: String
    @StateObject private var deepLinkObserver = EmailVerifyDeepLinkHandler()
    private static let defaultWait = 30
    @State var timeRemaining = CheckEmailVerification.defaultWait
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var inFlightRequest: Apollo.Cancellable?
    @State var error: Error?
    @State var code = ""
    @State var attemptId: String
    @State var pushNextStep = false
    @Environment(\.onboardingCompletion) var onboardingCompletion

    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Image("email_icon")
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .frame(width: 18, height: 18)
                            }
                            Spacer()
                        }
                    }
                Text("Check your email")
                    .font(.cut_title1)
                    .bold()
                Text("Open the link in the email we just sent you. Don't forget to check the spam folder in case it doesn't turn up.")
                    .multilineTextAlignment(.center)
            }
            OtpCodeTextField(text: $code, digitCount: 4) {
                authenticate()
            }
            PrimaryButton("Resend\(timeRemaining > 0 ? " (in \(timeRemaining) seconds)" : "")", isLoading: inFlightRequest != nil) {
                inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.InitiateAuthenticationMutation(email: email)) { result in
                    switch result.parseGraphQL() {
                    case .success(let data):
                        attemptId = data.initiateAuthentication
                        timeRemaining = type(of: self).defaultWait
                    case .failure(let error):
                        self.error = error
                    }
                    inFlightRequest = nil
                }
            }
            .disabled(timeRemaining != 0 || inFlightRequest != nil)
        }
        .padding(.horizontal, 16)
        .navigationDestination(isPresented: $pushNextStep) {
            CompleteAccountForm(
                email: email,
                authId: attemptId,
                code: code
            )
        }
        .onOpenURL(perform: { url in
            _ = deepLinkObserver.open(url)
        })
        .onReceive(timer, perform: { _ in
            timeRemaining = max(timeRemaining - 1, 0)
        })
        .onReceive(deepLinkObserver.$deepLinkCode, perform: { code in
            guard let code = code else { return }
            self.code = code

        })
        .errorAlert(error: $error)
    }

    private func authenticate() {
        guard inFlightRequest == nil else { return }
        let deviceName = UIDevice.current.name
        let mutation = CutGraphQL.ValidateAuthenticationMutation(id: attemptId, deviceName: deviceName, code: code)
        inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: mutation) { result in
            switch result.parseGraphQL() {
            case .success(let data):
                let r = data.validateAuthentication
                if let completeAccount = r.asCompleteAccountResult {
                    let account = completeAccount.completeAccount.fragments.completeAccountFragment
                    let sessionId = completeAccount.updatedDevice.session_id
                    try! SessionManager.shared.userLoggedIn(account: account, sessionId: sessionId)
                    onboardingCompletion()
                } else {
                    pushNextStep = true
                }
            case .failure(let error):
                self.error = error
                code = ""
            }
            inFlightRequest = nil
        }
    }
}

class EmailVerifyDeepLinkHandler: DeepLinkHandler, ObservableObject {
    @Published var deepLinkCode: String?
    var id: String = "EmailVerifyDeepLinkHandler"
    let regexes = [
        /.*cut\.watch\/verify-email.*/,
        /.*cut:\/\/verify-email.*/
    ]

    init() {
        DeepLinkManager.shared.add(self)
    }

    deinit {
        DeepLinkManager.shared.remove(self)
    }

    func open(_ url: URL) -> Bool {
        let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let queryItems = comps?.queryItems else { return false }

        let maybeToken = {
            for item in queryItems {
                if item.name == "code" {
                    return item.value
                }
            }
            return nil
        }()

        guard let token = maybeToken else { return false }
        deepLinkCode = token
        return true
    }
}

#Preview {
    CheckEmailVerification(
        email: "test@test.com",
        attemptId: ""
    )
}
