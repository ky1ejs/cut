//
//  WatchList.swift
//  Cut
//
//  Created by Kyle Satti on 2/20/24.
//

import SwiftUI
import Apollo

struct WatchList: View {
    @State var viewModels: [ContentRowViewModel] = []
    @State private var watcher: GraphQLQueryWatcher<CutGraphQL.WatchListQuery>?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModels, id: \.movie.id) { vm in
                    NavigationLink(destination: DetailView(movie: vm.movie)) {
                        ContentRow(viewModel: vm)
                    }
                }
            }
            .listStyle(.plain)
        }
        .task {
            self.watcher?.cancel()
            self.watcher = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.WatchListQuery(), resultHandler: { result in
                guard let data = try? result.get().data?.watchList else { return }
                print(data.first?.isOnWatchList)
                self.viewModels = data.enumerated().map { index, movie in ContentRowViewModel(movie: movie.fragments.movieFragment, index: index) }
            })
        }
    }
}

#Preview {
    WatchList()
}
