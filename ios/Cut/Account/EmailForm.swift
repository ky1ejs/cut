//
//  EmailForm.swift
//  Cut
//
//  Created by Kyle Satti on 5/19/24.
//

import SwiftUI
import Apollo

struct EmailForm: View {
    @Environment(\.theme) var theme
    @State var email = ""
    @State var attemptId: String?
    @State var request: Apollo.Cancellable?
    @State var error: Error?

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                VStack {
                    Image("email_icon")
                        .frame(width: 72, height: 72)
                    Text("What's your email?")
                        .font(.cut_title1)
                        .bold()
                }
                VStack(spacing: 8) {
                    TextField(text: $email, label: {
                        Text(verbatim: "your@email.com")
                    })
                    .textFieldStyle(CutTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onSubmit {
                        authenticate()
                    }
                    Text("By entering your email, you're agreeing to our terms of service and privacy policy.")
                        .font(.footnote)
                        .foregroundStyle(theme.subtitle.color)
                        .multilineTextAlignment(.center)
                }
            }
            .offset(y: -80)
            VStack {
                Spacer()
                PrimaryButton("Next", isLoading: request != nil) {
                    authenticate()
                }
                .safeAreaPadding(.bottom, 20)
                .disabled(email.count <= 4 || request != nil)
            }
        }
        .padding(.horizontal, 24)
        .errorAlert(error: $error)
        .navigationDestination(item: $attemptId) { id in
            CheckEmailVerification(email: email, attemptId: id)
        }
    }

    func authenticate() {
        request = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.InitiateAuthenticationMutation(email: email)) { result in
            request = nil
            switch result.parseGraphQL() {
            case .success(let data):
                attemptId = data.initiateAuthentication
            case .failure(let error):
                self.error = error
            }
        }
    }
}

import Combine

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Self.Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

#Preview {
    EmailForm()
}
