//
//  Account.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI
import Combine
import Apollo

class AccountViewModel: ObservableObject {
    @Published var isCompleteAccountPresented = false
    @Published var isAccountExplainerPresented = false
    let accountCompletionController = AccountCompletionController()
    var cancelable: AnyCancellable?
    var watch: Apollo.Cancellable?

    init() {
        cancelable = accountCompletionController.$isFinished.sink { [weak self] isFinished in
            guard isFinished else { return }
            self?.isCompleteAccountPresented = false
            self?.isAccountExplainerPresented = false
        }
    }

    deinit {
        cancelable?.cancel()
        watch?.cancel()
    }
}

struct Account: View {
    @ObservedObject var viewModel = AccountViewModel()
    @State private var state = ViewState.loading
    @State private var presentSettings = false

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
                Profile(profile: .completeAccount(account))
            case .incomplete:
                IncompleteAccount(viewModel: viewModel)
            case .error(let message):
                Text("Error: \(message)")
            }
        }
        .sheet(isPresented: $viewModel.isCompleteAccountPresented, content: {
            InitiateEmailConfirm()
                .environmentObject(viewModel.accountCompletionController)
        })
        .sheet(isPresented: $viewModel.isAccountExplainerPresented, content: {
            CompleteAccountBenefits(isPresented: $viewModel.isAccountExplainerPresented)
                .environmentObject(viewModel.accountCompletionController)
        })
        .sheet(isPresented: $presentSettings, content: {
            NavigationStack {
                Settings(isPresented: $presentSettings, isCompleteAccount: state.isCompleteAccount)
            }
        })
        .task {
            viewModel.watch?.cancel()
            viewModel.watch = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetAccountQuery()) { result in
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
            }
        }
        .animation(.linear(duration: 0.1), value: state)
    }
}

#Preview {
    Account()
}
