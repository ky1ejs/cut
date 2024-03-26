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

    enum ViewState {
        case loading
        case complete(CutGraphQL.CompleteAccountFragment)
        case incomplete(CutGraphQL.GetAccountQuery.Data.Account.AsIncompleteAccount)
        case error(String)
    }

    var body: some View {
        NavigationStack {
            switch state {
            case .loading:
                Text("loading...")
            case .complete(let account):
                CompleteAccount(account: account)
            case .incomplete:
                IncompleteAccount(viewModel: viewModel)
            case .error(let message):
                Text("Error: \(message)")
            }
        }
        .padding(.horizontal, 12)
        .sheet(isPresented: $viewModel.isCompleteAccountPresented, content: {
            InitiateEmailConfirm()
                .environmentObject(viewModel.accountCompletionController)
        })
        .sheet(isPresented: $viewModel.isAccountExplainerPresented, content: {
            CompleteAccountBenefits(isPresented: $viewModel.isAccountExplainerPresented)
                .environmentObject(viewModel.accountCompletionController)
        })
        .task {
            state = .loading
            viewModel.watch?.cancel()
            viewModel.watch = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetAccountQuery()) { result in
                switch result {
                case .success(let response):
                    if let completeAccount = response.data?.account.asCompleteAccount {
                     
                        state = .complete(completeAccount.fragments.completeAccountFragment)
                    } else if let incompleteAccount = response.data?.account.asIncompleteAccount {
                        state = .incomplete(incompleteAccount)
                    } else {
                        state = .error("Unknown")
                    }
                case .failure(let error):
                    state = .error(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    Account()
}
