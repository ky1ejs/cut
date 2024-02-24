//
//  Search.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI
import Combine
import Apollo

typealias Movie = CutGraphQL.MovieFragment

class SearchViewModel: ObservableObject {
    // inspired by: https://designcode.io/swiftui-advanced-handbook-search-feature
    @Published var searchTerm = ""
    @Published var results: [Movie] = []
    private var searchCancellable: AnyCancellable?
    private var inFlightRequest: Apollo.Cancellable?

    init() {
        searchCancellable = _searchTerm
            .projectedValue.debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] term in
                self?.inFlightRequest = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.SearchQuery(term: term)) { [weak self] result in
                    guard case .success(let data) = result, let r = data.data else { return }
                    self?.results = r.search.map { $0.fragments.movieFragment }
                }
            }

    }

    deinit {
        searchCancellable?.cancel()
        inFlightRequest?.cancel()
    }
}

struct Search: View {
    @ObservedObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.results, id: \.id) { movie in
                    ContentRow(viewModel: ContentRowViewModel(movie: movie))
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
