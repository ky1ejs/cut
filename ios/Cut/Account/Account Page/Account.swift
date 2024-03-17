//
//  Account.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI
import Combine

class AccountViewModel: ObservableObject {
    @Published var isCompleteAccountPresented = false
    @Published var isAccountExplainerPresented = false
    let accountCompletionController = AccountCompletionController()
    var cancelable: AnyCancellable?

    init() {
        cancelable = accountCompletionController.$isFinished.sink { [weak self] isFinished in
            guard isFinished else { return }
            self?.isCompleteAccountPresented = false
            self?.isAccountExplainerPresented = false
        }
    }

    deinit {
        cancelable?.cancel()
        cancelable = nil
    }
}

struct Account: View {
    @ObservedObject var viewModel = AccountViewModel()
    @State private var state = ViewState.loading

    enum ViewState {
        case loading
        case complete(CutGraphQL.GetAccountQuery.Data.Account.AsCompleteAccount)
        case incomplete(CutGraphQL.GetAccountQuery.Data.Account.AsIncompleteAccount)
        case error
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
            case .error:
                Text("Error")
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
            AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetAccountQuery()) { result in
                if let completeAccount = try? result.get().data?.account.asCompleteAccount {
                    state = .complete(completeAccount)
                } else if let incompleteAccount = try? result.get().data?.account.asIncompleteAccount {
                    state = .incomplete(incompleteAccount)
                } else {
                    state = .error
                }
            }
        }
    }
}

#Preview {
    Account()
}
