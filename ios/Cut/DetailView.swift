//
//  DetailView.swift
//  Cut
//
//  Created by Kyle Satti on 2/23/24.
//

import SwiftUI
import Apollo
import Kingfisher

struct DetailView: View {
    let content: Movie
    @State var extendedContent: CutGraphQL.GetContentQuery.Data.Content?
    @State var watched: Apollo.GraphQLQueryWatcher<CutGraphQL.GetContentQuery>?

    var body: some View {
        let type = extendedContent?.type ?? content.type
        ZStack {
            if case .case(.movie) = type {
                let movie = extendedContent != nil ? extendedContent!.result.asExtendedMovie!.fragments.extendedMovieFragment : nil
                MovieDetailView(movie: content, extendedMovie: movie)
            } else if case .case(.tvShow) = type {
                let tvShow = extendedContent != nil ? extendedContent!.result.asExtendedTVShow!.fragments.extendedTVShowFragment : nil
                TVShowDetailView(movie: content, tvShow: tvShow)
            } else {
                fatalError("Unknown content")
            }
        }
        .environment(\.theme, DarkTheme())
        .animation(.linear(duration: 0.4), value: extendedContent)
        .onAppear {
            watched?.cancel()
            watched = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetContentQuery(id: content.id)) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    extendedContent = data.content
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct DetailViewContainer<C: View>: View {
    @Environment(\.theme) var theme
    let content: Movie
    @ViewBuilder let child: (CGFloat) -> C

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        child(proxy.size.width)
                    }
                    .safeAreaPadding(.top, 20)
                    .safeAreaPadding(.horizontal, 20)
                    .padding(.bottom, 100)
                    .scrollClipDisabled()
                }
                VStack {
                    Spacer()
                    HStack(spacing: 18) {
                        Spacer()
                        CircleWatchListButton(movie: content)
                        CircleButton(kind: .watched) {

                        }
                        ShareLink(item: content.url) {
                            Image("paper_airplane")
                                .colorMultiply(UIColor.gray05.color)
                        }
                        .buttonStyle(CircleButtonStyle())
                        Spacer()
                    }
                    .padding(.top, 18)
                    .safeAreaPadding(.bottom, 32)
                    .background {
                        LinearGradient(gradient: Gradient(colors: [.clear, theme.background.color]), startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 0.5))
                            .fixedSize(horizontal: false, vertical: false)
                            .ignoresSafeArea()
                    }
                }
            }
            .background {
                KFImage(content.poster_url)
                    .resizable()
                    .blur(radius: 90)
                    .saturation(0.4)
                    .brightness(-0.3)
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    DetailView(content: Mocks.movie)
}
