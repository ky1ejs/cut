//
//  Browse.swift
//  Cut
//
//  Created by Kyle Satti on 2/20/24.
//

import SwiftUI
import Apollo

struct Browse: View {
    @State var trending: [Movie] = []
    @State var new: [Movie] = []
    @State var topRated: [Movie] = []
    @State private var watched: GraphQLQueryWatcher<CutGraphQL.MoviesQuery>?

    var body: some View {
        ScrollView {
            VStack {
                PosterCarousel(title: "Trending", movies: trending, style: .ordered)
                PosterCarousel(title: "New", movies: new, style: .unordered)
                PosterCarousel(title: "Top Rated", movies: topRated, style: .unordered)
                Spacer()
            }
            .scrollClipDisabled()
            .scrollBounceBehavior(.basedOnSize)
            .onAppear {
                watched = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.MoviesQuery(collection: .case(.trendingWeekly)), resultHandler: { result in
                    guard let data = try? result.get().data?.movies else { return }
                    let movies = data.map { $0.fragments.movieFragment }
                    self.trending = movies
                })
                AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.MoviesQuery(collection: .case(.nowPlaying)), resultHandler: { result in
                    guard let data = try? result.get().data?.movies else { return }
                    let movies = data.map { $0.fragments.movieFragment }
                    self.new = movies
                })
                AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.MoviesQuery(collection: .case(.topRated)), resultHandler: { result in
                    guard let data = try? result.get().data?.movies else { return }
                    let movies = data.map { $0.fragments.movieFragment }
                    self.topRated = movies
                })
            }
            .padding(.leading, 10)
        }
        .onDisappear {
            watched?.cancel()
            watched = nil
        }
    }
}

struct PosterCarousel: View {
    let title: String
    let movies: [Movie]
    let style: Style
    enum Style {
        case ordered, unordered
    }
    var body: some View {
        HStack {
            Text(title).font(.title).bold()
            Spacer()
        }
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(content: {
                ForEach(Array(movies.enumerated()), id: \.element.id) { i, m in
                    NavigationLink(destination: DetailView(movie: m)) {
                        switch style {
                        case .ordered:
                            OrderedPosterCard(movie: m, index: i + 1)
                                .padding(.trailing, 10)
                        case .unordered:
                            PosterCard(movie: m)
                        }
                    }
                }
            })
        }
        .frame(height: 165)
    }
}

struct PosterCard: View {
    let movie: Movie
    var body: some View {
        URLImage(url: URL(string: movie.poster_url)!)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .frame(width: 110, height: 170)
    }
}

struct OrderedPosterCard: View {
    let movie: Movie
    let index: Int
    var body: some View {
        HStack {
            PosterCard(movie: movie)
            Text("\(index)")
                .font(.system(size: 230, weight: .bold, design: .rounded))
                .offset(CGSize(width: -35, height: 0))
                .zIndex(-1)
                .padding(.trailing, -30)
        }
    }
}

#Preview {
    Browse()
}
