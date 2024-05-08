//
//  Search.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI
import Combine
import Apollo

class SearchViewModel: ObservableObject {
    // inspired by: https://designcode.io/swiftui-advanced-handbook-search-feature
    @Published var searchTerm = ""
    @Published var state = State.results([])
    private var bag = [AnyCancellable]()

    enum State {
        case searching(Apollo.Cancellable?)
        case results([Movie])
        case error(Error)

        var results: [Movie] {
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

    init() {
        let searchCancellable = _searchTerm
            .projectedValue.debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] term in
                self?.state.cancelInflightSearch()
                let request = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.SearchQuery(term: term)) { [weak self] result in
                    switch result.parseGraphQL() {
                    case .success(let data):
                        self?.state = .results(data.search.map { $0.fragments.movieFragment})
                    case .failure(let error):
                        self?.state = .error(error)
                    }
                }
                self?.state = .searching(request)
            }
        let loadingCancellable = _searchTerm.projectedValue.sink { [weak self] term in
            self?.state = term.isEmpty ? .results([]) : .searching(nil)
        }
        bag = [searchCancellable, loadingCancellable]
    }

    deinit {
        bag.forEach { $0.cancel() }
        state.cancelInflightSearch()
    }
}

struct Search: View {
    @ObservedObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            List {
                switch viewModel.state {
                case .searching:
                    ProgressView()
                case .results(let results):
                    ForEach(results, id: \.id) { movie in
                        NavigationLink {
                            DetailView(content: movie)
                        } label: {
                            ContentRow(viewModel: ContentRowViewModel(movie: movie))
                        }
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Search")
        }
        .searchable(text: $viewModel.searchTerm, prompt: "Look for something")
    }
}

#Preview {
    Search()
}
