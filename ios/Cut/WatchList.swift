//
//  WatchList.swift
//  Cut
//
//  Created by Kyle Satti on 2/20/24.
//

import SwiftUI
import Apollo

struct WatchList: View {
    @Environment(\.theme) var theme
    @State var movies: [Movie] = []
    @State private var watcher: GraphQLQueryWatcher<CutGraphQL.WatchListQuery>?
    @State private var presentedContent: Movie?

    var body: some View {
        NavigationStack {
            if movies.isEmpty {
                VStack {
                    Spacer()
                    Text("Nothing on your list")
                        .multilineTextAlignment(.center)
                        .font(.cut_title1)
                        .foregroundStyle(theme.subtitle.color)
                    Text("Movies & TV Shows you want to watch will show here")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(theme.subtitle.color)
                    Spacer()
                }
                .padding(.horizontal, 32)
            } else {
                List {
                    ForEach(movies, id: \.id) { m in
                        Button(action: {
                            presentedContent = m
                        }, label: {
                            ContentRow(movie: m)
                        })
                    }
                }
                .listStyle(.plain)
            }
        }
        .sheet(item: $presentedContent, content: { c in
            DetailView(content: c)
        })
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
        .animation(.linear, value: movies)
    }
}

#Preview {
    WatchList()
}
