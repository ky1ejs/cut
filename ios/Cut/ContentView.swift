//
//  ContentView.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State var data: [CutGraphQL.MovieFragment]?

    var body: some View {
        TabView {
            List {
                if let data = data {
                    ForEach(data, id: \.id) { m in
                        ContentRow(viewModel: ContentRowViewModel(movie: m))
                    }
                }
            }
            .listStyle(.plain)
            .task {
                AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.ExampleQuery(), resultHandler: { result in
                    guard let data = try? result.get().data?.movies else { return }
                    let movies = data.map { $0.fragments.movieFragment }
                    self.data = movies
                })
            }.tabItem {
                Label("Feed", systemImage: "film")
            }
            Search()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            Account()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
