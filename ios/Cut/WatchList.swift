//
//  WatchList.swift
//  Cut
//
//  Created by Kyle Satti on 2/20/24.
//

import SwiftUI
import Apollo

struct WatchList: View {
    @State var movies: [Movie] = []
    @State private var watcher: GraphQLQueryWatcher<CutGraphQL.WatchListQuery>?

    var body: some View {
        NavigationStack {
            List {
                ForEach(movies, id: \.id) { m in
                    NavigationLink(destination: DetailView(content: m)) {
                        ContentRow(movie: m)
                    }
                }
            }
            .listStyle(.plain)
        }
        .task {
            self.watcher?.cancel()
            self.watcher = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.WatchListQuery(), resultHandler: { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    self.movies = data.watchList.map { $0.fragments.movieFragment }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
}

#Preview {
    WatchList()
}
