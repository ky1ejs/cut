//
//  Browse.swift
//  Cut
//
//  Created by Kyle Satti on 2/20/24.
//

import SwiftUI
import Apollo

struct Browse: View {
    @State var data: [CutGraphQL.MovieFragment]?
    @State private var watched: GraphQLQueryWatcher<CutGraphQL.MoviesQuery>?

    var body: some View {
        List {
            if let data = data {
                ForEach(data, id: \.id) { m in
                    ContentRow(viewModel: ContentRowViewModel(movie: m))
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            watched = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.MoviesQuery(collection: .case(.popular)), resultHandler: { result in
                guard let data = try? result.get().data?.movies else { return }
                let movies = data.map { $0.fragments.movieFragment }
                self.data = movies
            })
        }
        .onDisappear {
            watched?.cancel()
            watched = nil
        }
    }
}

#Preview {
    Browse()
}
