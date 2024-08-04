//
//  Browse.swift
//  Cut
//
//  Created by Kyle Satti on 2/20/24.
//

import SwiftUI
import Apollo

struct Browse: View {
    @State var trending: [Content] = []
    @State var new: [Content] = []
    @State var topRated: [Content] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    PosterCarousel(title: "Trending", content: trending, style: .ordered)
                    PosterCarousel(title: "New", content: new, style: .unordered)
                    PosterCarousel(title: "Top Rated", content: topRated, style: .unordered)
                    Spacer()
                }
                .scrollClipDisabled()
                .scrollBounceBehavior(.basedOnSize)
                .onAppear {
                    AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetContentCollectionQuery(collection: .case(.trendingWeekly)), resultHandler: { result in
                        switch result.parseGraphQL() {
                        case .success(let data):
                            let movies = data.contentCollection.map { $0.fragments.contentFragment }
                            self.trending = movies
                        case .failure(let error):
                            print(error)

                        }
                    })
                    AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetContentCollectionQuery(collection: .case(.nowPlaying)), resultHandler: { result in
                        switch result.parseGraphQL() {
                        case .success(let data):
                            self.new = data.contentCollection.map { $0.fragments.contentFragment }
                        case .failure(let error):
                            print(error)

                        }
                    })
                    AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetContentCollectionQuery(collection: .case(.topRated)), resultHandler: { result in
                        switch result.parseGraphQL() {
                        case .success(let data):
                            self.topRated = data.contentCollection.map { $0.fragments.contentFragment }
                        case .failure(let error):
                            print(error)

                        }
                    })
                }
                .padding(.leading, 10)
            }
        }
    }
}

struct PosterCarousel: View {
    let title: String
    let content: [Content]
    let style: Style
    @State var presentedContent: Content?

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
                ForEach(Array(content.enumerated()), id: \.element.id) { i, c in
                    Button {
                        presentedContent = c
                    } label: {
                        switch style {
                        case .ordered:
                            OrderedPosterCard(content: c, index: i + 1)
                                .padding(.trailing, 10)
                        case .unordered:
                            PosterCard(content: c)
                        }
                    }
                }
            })
        }
        .sheet(item: $presentedContent, content: { m in
            NavigationStack {
                ContentDetailView(content: m)
            }
        })
        .frame(height: 165)
        .animation(.linear, value: content)
    }
}

struct PosterCard: View {
    let content: Content
    var body: some View {
        URLImage(url: content.poster_url)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .frame(width: 110, height: 170)
    }
}

struct OrderedPosterCard: View {
    let content: Content
    let index: Int
    var body: some View {
        HStack {
            PosterCard(content: content)
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
