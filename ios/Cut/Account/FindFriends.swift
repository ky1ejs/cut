//
//  FindFriends.swift
//  Cut
//
//  Created by Kyle Satti on 5/21/24.
//

import SwiftUI
import ContactsUI

struct FindFriends: View {
    @State var state: ViewState
    @State var presentExplanation = false
    @State var pushNextStep = false
    @Environment(\.onboardingCompletion) var onboardingCompletion

    enum ViewState: Equatable {
        static func == (lhs: FindFriends.ViewState, rhs: FindFriends.ViewState) -> Bool {
            switch (lhs, rhs) {
            case (.notDetermined, .notDetermined): return true
            case (.denied, .denied): return true
            case (.authorized, .authorized): return true
            case (.authorizing, .authorizing): return true
            case (.error, .error): return true
            default: return false
            }
        }
        
        case notDetermined, denied, authorized, authorizing
        case error(Error)
    }

    init() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .restricted: state = .authorized
        case .denied: state = .denied
        case .notDetermined: state = .notDetermined
        @unknown default:
            fatalError()
        }
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack(spacing: 8) {
                Text("Cut is better with friends")
                    .font(.cut_title1)
                    .bold()
                Text("Follow your friends to see what they've been watching, share and receive recommendations, and more.")
                    .multilineTextAlignment(.center)
            }
            HStack(spacing: 18) {
                Image("content_2")
                    .resizable()
                    .frame(width: 60, height: 60 * 1.64)
                    .mask {
                        RoundedRectangle(cornerRadius: 10)
                    }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image("friend_small")
                        Text("Sabrina just watched")
                            .font(.cut_footnote)
                            .fontWeight(.light)
                    }
                    Text("Dune: Part 2")
                        .font(.cut_title3)
                        .bold()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .foregroundStyle(UIColor.gray50.color)
                            .frame(width: 18, height: 18)
                        Text("8.9 • Sci-Fi • 2024")
                            .font(.cut_subheadline)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(UIColor.gray90.color)
            .mask {
                RoundedRectangle(cornerRadius: 10)
            }
            Spacer()
            VStack {
                PrimaryButton("Find my friends") {
                    if case .authorized = state {
                        pushNextStep = true
                    } else {
                        presentExplanation = true
                    }
                }
                TertiaryButton("Not now") {
                    onboardingCompletion()
                }
            }
        }
        .padding(.horizontal, 23)
        .sheet(isPresented: $presentExplanation) {
            VStack(spacing: 32) {
                switch state {
                case .notDetermined:
                    VStack(spacing: 8) {
                        Text("Find friends via contacts")
                            .font(.cut_title1)
                            .bold()
                        Text("""
                Your contacts will encypted on your device before they are sent to Cut's servers; Cut are unable to see your contacts or use them for their own purposes.
                """)
                        .bold()
                        .multilineTextAlignment(.center)
                    }
                    VStack {
                        PrimaryButton("Allow access to Contacts") {
                            CNContactStore().requestAccess(for: .contacts) { granted, error in
                                if let error = error {
                                    state = .error(error)
                                } else {
                                    state = granted ? .authorized : .denied
                                    if granted {
                                        pushNextStep = true
                                        presentExplanation = false
                                    }
                                }
                            }
                        }
                        TertiaryButton("Not now") {
                            presentExplanation = false
                        }
                    }
                case .denied:
                    Text("You've denied access for Cut to use your contacts to privately find your friends.")

                    PrimaryButton("Allow access in Settings") {

                    }
                case .authorizing:
                    EmptyView()
                case .authorized:
                    Text("Error")
                case .error(let error):
                    Text("Error " + error.localizedDescription)
                }
            }
            .padding(.horizontal, 12)
            .presentationDetents([.fraction(0.4)])
        }
        .navigationDestination(isPresented: $pushNextStep) {
            FindFriendsViaContacts()
                .environment(\.findFriendsCompletionHandler) {
                    SessionManager.shared.isOnboarding = false
                }
        }
    }
}

#Preview {
    FindFriends()
}
