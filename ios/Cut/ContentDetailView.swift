//
//  DetailView.swift
//  Cut
//
//  Created by Kyle Satti on 2/23/24.
//

import SwiftUI
import Apollo
import Kingfisher

struct ContentDetailView: View {
    @State var content: Content
    @State var extendedContent: CutGraphQL.GetContentQuery.Data.Content?
    @State var watched: Apollo.GraphQLQueryWatcher<CutGraphQL.GetContentQuery>?

    var body: some View {
        let type = extendedContent?.type ?? content.type
        ZStack {
            if case .case(.movie) = type {
                let movie = extendedContent != nil ? extendedContent!.result.asExtendedMovie!.fragments.extendedMovieFragment : nil
                MovieDetailView(content: content, extendedMovie: movie)
            } else if case .case(.tvShow) = type {
                let tvShow = extendedContent != nil ? extendedContent!.result.asExtendedTVShow!.fragments.extendedTVShowFragment : nil
                TVShowDetailView(content: content, tvShow: tvShow)
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
                    if let content =
                        data.content.result.fragments.extendedContentUnionFragment.asContentInterface?.fragments.contentFragment {
                        self.content = content
                    }
                    extendedContent = data.content
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentDetailViewContainer<C: View>: View {
    @Environment(\.theme) var theme
    let content: Content
    @ViewBuilder let child: (CGFloat) -> C
    @State var ratingViewPresented = false

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
                        CircleWatchListButton(content: content)
                        CircleButton(kind: .watched) {
                            ratingViewPresented = true
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
            .sheet(isPresented: $ratingViewPresented) {
                RateContentSheet(contentId: content.id)
            }
        }
    }
}

#Preview {
    ContentDetailView(content: Mocks.content)
}
