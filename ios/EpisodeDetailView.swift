//
//  EpisodeDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 5/15/24.
//

import SwiftUI
import Kingfisher

struct EpisodeDetailView: View {
    @Environment(\.theme) var theme
    let seriesId: String
    let episode: CutGraphQL.EpisodeFragment
    @State var extendedEpisode: CutGraphQL.ExtendedEpisodeFragment?
    let padding: CGFloat = 12
    let imagePadding: CGFloat = 26
    var subtitle: String {
        [
            "Episode #\(episode.episode_number)",
            episode.air_date != nil ? Formatters.fullDF.string(from: episode.air_date!) : nil,
            episode.runtime?.runtimeString
        ]
            .compactMap { $0 }
            .joined(separator: " • ")
    }
    var stills: [URL] {
        [episode.still_url] + (extendedEpisode?.stills ?? [])
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    VStack(spacing: 8) {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 8) {
                                ForEach(stills, id: \.absoluteString) { url in
                                    KFImage(url)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(
                                            width: proxy.size.width - padding * 2 - imagePadding * 2,
                                            height: proxy.size.width * 0.8 * 0.7
                                        )
                                        .mask {
                                            RoundedRectangle(cornerRadius: 16)
                                        }
                                        .clipped()
                                }
                            }
                        }
                        .padding(.leading, imagePadding)
                        .fixedSize(horizontal: false, vertical: true)
                        Text(subtitle)
                            .font(.cut_subheadline)
                            .foregroundStyle(theme.subtitle.color)
                    }
                    Text(episode.name)
                        .font(.cut_title1)
                        .bold()
                    LongText(episode.overview)
                        .multilineTextAlignment(.center)
                    CastCarousel(
                        cast: extendedEpisode?.cast.map { $0.fragments.personFragment },
                        crew: extendedEpisode?.crew.map { $0.fragments.personFragment },
                        mapper: PersonPersonable(),
                        tableMapper: PersonEntityMapper()
                    )
                }
                .scrollClipDisabled()
                .padding(.horizontal, padding)
            }
            .scrollBounceBehavior(.basedOnSize)
            .animation(.linear(duration: 0.4), value: extendedEpisode)
            .onAppear {
                AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetEpisodeQuery(
                    seriesId: seriesId, seasonNumber: episode.season_number, episodeNumber: episode.episode_number)) { result in
                        switch result.parseGraphQL() {
                        case .success(let data):
                            extendedEpisode = data.episode.fragments.extendedEpisodeFragment
                        case .failure(let error):
                            print(error)
                        }
                    }
            }
        }
    }
}

#Preview {
    EpisodeDetailView(seriesId: "1234", episode: Mocks.episode)
}
