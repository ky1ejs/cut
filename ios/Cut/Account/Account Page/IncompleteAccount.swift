//
//  IncompleteAccount.swift
//  Cut
//
//  Created by Kyle Satti on 3/14/24.
//

import SwiftUI

private struct OnboardingCompletionKey: EnvironmentKey {
    static var defaultValue: () -> Void = {}
}

extension EnvironmentValues {
  var onboardingCompletion: () -> Void {
    get { self[OnboardingCompletionKey.self] }
    set { self[OnboardingCompletionKey.self] = newValue }
  }
}

struct IncompleteAccount: View {
    @State private var isSettingsPresented = false
    let onboardingCtaPressed: () -> ()
    let explanationCtaPressed: () -> ()

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isSettingsPresented = true
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .tint(.gray)
                            .padding(.horizontal, 18)
                    }
                }
                Text("Complete your account to keep your data safe and follow friends").font(.title2).multilineTextAlignment(.center)
                Spacer(minLength: 48)
                PrimaryButton("Complete my account") {
                    onboardingCtaPressed()
                }
                TertiaryButton("Why do I need an account?") {
                    explanationCtaPressed()
                }
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 16)
        }
        .sheet(isPresented: $isSettingsPresented, content: {
            NavigationStack {
                Settings(isPresented: $isSettingsPresented, isCompleteAccount: false)
            }
        })
    }
}

