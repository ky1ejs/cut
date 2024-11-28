//
//  Account.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI
import Combine
import Apollo

struct Account: View {
    @State private var state = ViewState.loading
    @State private var presentSettings = false
    @State private var watch: Apollo.Cancellable?

    // needs to be at this level so that when the watch refreshes
    // the onboarding can continue past account creation
    @State private var presentOnboarding = false
    @State private var isAccountExplainerPresented = false


    enum ViewState: Equatable {
        case loading
        case complete(CutGraphQL.CompleteAccountFragment)
        case incomplete(CutGraphQL.GetAccountQuery.Data.Account.AsIncompleteAccount)
        case error(String)

        var isCompleteAccount: Bool {
            if case .complete = self {
                return true
            }
            return false
        }
    }

    var body: some View {
        NavigationStack {
            switch state {
            case .loading:
                Text("loading...")
            case .complete(let account):
                HStack(spacing: 18) {
                    Spacer()
                    Button {
                        presentSettings = true
                    } label: {
                        Image(systemName: "at")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(.gray)
                    }
                    Button {
                        presentSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                Profile(profile: .completeAccount(account)) {
                    await fetch()
                }
            case .incomplete:
                IncompleteAccount {
                    presentOnboarding = true
                } explanationCtaPressed: {
                    isAccountExplainerPresented = true
                }

            case .error(let message):
                Text("Error: \(message)")
            }
        }
        .sheet(isPresented: $presentSettings, content: {
            NavigationStack {
                Settings(isPresented: $presentSettings, isCompleteAccount: state.isCompleteAccount)
            }
        })
        .task {
            await fetch()
        }
        .animation(.linear(duration: 0.1), value: state)
        .sheet(isPresented: $isAccountExplainerPresented, content: {
            CompleteAccountBenefits()
                .environment(\.onboardingCompletion) {
                    presentOnboarding = false
                }
        })
        .sheet(isPresented: $presentOnboarding, content: {
            NavigationStack {
                EmailForm()
            }
            .environment(\.onboardingCompletion) {
                presentOnboarding = false
            }
        }) 
    }

    private func fetch() async {
        await withCheckedContinuation { cont in
            watch?.cancel()
            watch = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetAccountQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    if let completeAccount = data.account.asCompleteAccount {
                        state = .complete(completeAccount.fragments.completeAccountFragment)
                    } else if let incompleteAccount = data.account.asIncompleteAccount {
                        state = .incomplete(incompleteAccount)
                    } else {
                        state = .error("Unknown")
                    }
                case .failure(let error):
                    state = .error(error.localizedDescription)
                }
                cont.resume()
            }
        }
    }
}

#Preview {
    Account()
}
