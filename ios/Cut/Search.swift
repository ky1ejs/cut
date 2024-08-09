//
//  Search.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI
import Combine
import Apollo

// inspired by: https://designcode.io/swiftui-advanced-handbook-search-feature
class SearchViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var contentState = State<Content>.results([])
    @Published var accountState = State<CutGraphQL.ProfileFragment>.results([])
    private var bag = [AnyCancellable]()

    enum Entity: CaseIterable, Identifiable {
           case content, accounts

           var displayName: String {
               switch self {
               case .content:
                   return "Movies, Shows & People"
               case .accounts:
                   return "Accounts"
               }
           }

           var id: String { displayName }
       }

    enum State<T> {
        case searching(Apollo.Cancellable?)
        case results([T])
        case error(Error)

        var results: [T] {
            if case .results(let results) = self {
                return results
            }
            return []
        }

        fileprivate func cancelInflightSearch() {
            if case .searching(let request) = self {
                request?.cancel()
            }
        }
    }

    init(searchEntities: [Entity] = [.content]) {
        let searchCancellable = _searchTerm
            .projectedValue.debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] term in
                self?.contentState.cancelInflightSearch()
                self?.accountState.cancelInflightSearch()

                if searchEntities.contains(.content) {
                    let request = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.SearchQuery(term: term)) { [weak self] result in
                        switch result.parseGraphQL() {
                        case .success(let data):
                            self?.contentState = .results(data.search.map { $0.fragments.contentFragment})
                        case .failure(let error):
                            self?.contentState = .error(error)
                        }
                    }
                    self?.contentState = .searching(request)
                }

                if searchEntities.contains(.accounts) {
                    let accountRequest = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.SearchAccountsQuery(term: term)) { [weak self] result in
                        switch result.parseGraphQL() {
                        case .success(let data):
                            self?.accountState = .results(data.searchUsers.map { $0.fragments.profileFragment})
                        case .failure(let error):
                            self?.accountState = .error(error)
                        }
                    }
                    self?.accountState = .searching(accountRequest)
                }
            }

        let loadingCancellable = _searchTerm.projectedValue.sink { [weak self] term in
            self?.accountState = term.isEmpty ? .results([]) : .searching(nil)
            self?.contentState = term.isEmpty ? .results([]) : .searching(nil)
        }
        bag = [searchCancellable, loadingCancellable]
    }

    deinit {
        bag.forEach { $0.cancel() }
        contentState.cancelInflightSearch()
        accountState.cancelInflightSearch()
    }
}

struct Search: View {
    @ObservedObject private var viewModel = SearchViewModel(searchEntities: SearchViewModel.Entity.allCases)
    @State var presentedContent: Content?
    @State var presentedProfile: CutGraphQL.ProfileFragment?
    @State var entity = SearchViewModel.Entity.content

    var body: some View {
        NavigationStack {
            Picker(selection: $entity) {
                ForEach(SearchViewModel.Entity.allCases) { s in
                    Text(s.displayName).tag(s)
                }
            } label: {
                Text("Ignored")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
            List {
                switch entity {
                case .content:
                    switch viewModel.contentState {
                    case .searching:
                        ProgressView()
                    case .results(let results):
                        ForEach(results, id: \.id) { content in
                            Button {
                                presentedContent = content
                            } label: {
                                ContentRow(content: content)
                            }
                        }
                    case .error(let error):
                        Text(error.localizedDescription)
                    }
                case .accounts:
                    switch viewModel.accountState {
                    case .searching:
                        ProgressView()
                    case .results(let results):
                        ForEach(results, id: \.id) { profile in
                            Button {
                                presentedProfile = profile
                            } label: {
                                ProfileRow(profile: profile)
                            }
                        }
                    case .error(let error):
                        Text(error.localizedDescription)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Search")
        }
        .searchable(text: $viewModel.searchTerm, prompt: "Look for something")
        .sheet(item: $presentedContent) { m in
            NavigationStack {
                ContentDetailView(content: m)
            }
        }
        .sheet(item: $presentedProfile) { p in
            NavigationStack {
                ProfileContainer(profile: p).padding(.top, 18)
            }
        }
    }
}

extension CutGraphQL.ProfileFragment: Identifiable {}

#Preview {
    Search()
}
