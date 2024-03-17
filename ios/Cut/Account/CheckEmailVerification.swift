//
//  CheckEmailVerification.swift
//  Cut
//
//  Created by Kyle Satti on 3/2/24.
//

import SwiftUI

struct CheckEmailVerification: View {
    @StateObject private var deepLinkObserver = EmailVerifyDeepLinkHandler()

    var body: some View {
        ZStack {
            Color.cutOrange
            VStack(spacing: 0) {
                Text("📧").font(.system(size: 120))
                    .padding(.bottom, 24)
                    .padding(.top, 80)
                Text("Check your email")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(.bottom, 24)
                Text("Open the link in the email we just sent you.\n\nRemember to check your spack if it doesn't turn up")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                Spacer()
            }.padding(.horizontal, 12)
        }
        .ignoresSafeArea()
        .navigationDestination(item: $deepLinkObserver.deepLinkToken) { token in
            CompleteAccountForm(emailVerificationToken: token)
        }
    }
}

class EmailVerifyDeepLinkHandler: DeepLinkHandler, ObservableObject {
    @Published var deepLinkToken: String?
    let id = "1234"
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
                if item.name == "token" {
                    return item.value
                }
            }
            return nil
        }()

        guard let token = maybeToken else { return false }
        deepLinkToken = token
        return true
    }
    

}

#Preview {
    CheckEmailVerification()
}
