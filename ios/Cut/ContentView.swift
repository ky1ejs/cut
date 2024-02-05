//
//  ContentView.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

struct ImageLoaderImpl: ImageLoader {
    func loadImage(_ url: String) async -> UIImage {
        return UIImage()
    }
}

struct ContentView: View {
    @State var data: [CutGraphQL.MovieFragment]?

    var body: some View {
        List {
            if let data = data {
                ForEach(data, id: \.id) { m in
                    ContentRow(viewModel: ContentRowViewModel(imageLoader: ImageLoaderImpl(), movie: m))
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
        }
    }
}

#Preview {
    ContentView()
}
