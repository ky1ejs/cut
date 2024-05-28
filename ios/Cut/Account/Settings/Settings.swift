//
//  Settings.swift
//  Cut
//
//  Created by Kyle Satti on 2/27/24.
//

import SwiftUI
import Apollo

struct Settings: View {
    @State private var inFlightRequest: Cancellable?
    @State private var presentDelete = false
    @Binding var isPresented: Bool
    let isCompleteAccount: Bool

    var body: some View {
        List {
            NavigationLink("Changelog", destination: {
                Changelog()
            })
            HStack {
                Button(inFlightRequest != nil ? "Sending test push..." : "Send test push") {
                    inFlightRequest?.cancel()
                    inFlightRequest = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.SendTestPushQuery(), cachePolicy: .fetchIgnoringCacheCompletely, resultHandler: { result in
                        inFlightRequest = nil
                    })
                }
                .disabled(inFlightRequest != nil)
                Spacer()
                if inFlightRequest != nil {
                    ProgressView()
                }
            }
            NavigationLink("Find friends", destination: {
                FindFriendsViaContacts() {
                    SessionManager.shared.isOnboarding = false
                }
            })
            if isCompleteAccount {
                Button("Log out") {
                    try! SessionManager.shared.logOut()
                }
            }
            Button("Delete my account") {
                presentDelete = true
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            Button("Done") {
                isPresented = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $presentDelete, content: {
            DeleteAccountView()
        })
    }
}

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    @State var state = ViewState.loadingCode

    enum ViewState {
        case loadingCode
        case ready(String)
        case deleteing
        case error(Error)
    }

    var body: some View {
        VStack {
            switch state {
            case .loadingCode:
                ProgressView()
                Text("Preparing to delete your account. Don't worry, you'll be able to confirm before we go ahead.")
                TertiaryButton("Cancel") {
                    dismiss()
                }
            case .ready(let code):
                PrimaryButton("Yes, I'd like to permanently delete my account") {
                    state = .deleteing
                    AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.DeleteAccountMutation(code: code)) { result in
                        switch result.parseGraphQL() {
                        case .success:
                            try! SessionManager.shared.accountDeleted()
                        case .failure(let error):
                            state = .error(error)
                        }
                    }
                }
                TertiaryButton("I've changed my mind") {
                    dismiss()
                }
            case .deleteing:
                ProgressView()
                Text("...deleting your account")
            case .error(let error):
                Text("There's been an error")
                Text(error.localizedDescription)
                TertiaryButton("Dismiss") {
                    dismiss()
                }
            }
        }
        .onAppear {
            AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.InitiatiteDeleteAccountMutation()) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    state = .ready(data.generateDeleteAccountCode)
                case .failure(let error):
                    state = .error(error)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        Settings(isPresented: Binding.constant(true), isCompleteAccount: true)
    }
}
