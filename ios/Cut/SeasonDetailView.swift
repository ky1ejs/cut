//
//  SeasonDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 5/11/24.
//

import SwiftUI

struct SeasonDetailView: View {
    let show: Content
    let season: CutGraphQL.SeasonFragment
    @State var extendedSeason: CutGraphQL.ExtendedSeasonFragment?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    PosterImage(url: season.poster_url)
                    VStack(alignment: .leading) {
                        Text(season.name)
                            .font(.cut_title1)
                        VStack(alignment: .leading) {
                            if let date = season.air_date {
                                Text("Aired: " + Formatters.fullDF.string(from: date))
                            }
                        }
                    }
                    Spacer()
                }
                LongText(season.overview)
                    .multilineTextAlignment(.center)
                if let extendedSeason = extendedSeason {
                    Text("Episodes (\(String(extendedSeason.episode_count)))")
                        .font(.cut_title1)
                } else {
                    Text(String.placeholder(length: 15))
                        .font(.cut_title1)
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
                EpisodeCarousel(
                    seriesId: show.id,
                    episodes: extendedSeason?.episodes.map { $0.fragments.episodeFragment }
                )
                CastCarousel(
                    cast: extendedSeason?.cast.map { $0.fragments.seasonPersonFragment },
                    crew: extendedSeason?.crew.map { $0.fragments.seasonPersonFragment },
                    mapper: SeasonPersonPersonable(),
                    tableMapper: SeasonPersonEntityMapper()
                )
            }
            .padding(.horizontal, 24)
            .scrollClipDisabled()
        }
        .animation(.linear(duration: 0.4), value: season)
        .onAppear {
            AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetSeasonQuery(seriesId: show.id, seasonNumber: season.season_number)) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    extendedSeason = data.season.fragments.extendedSeasonFragment
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}


extension CutGraphQL.SeasonPersonFragment: Identifiable {}

struct SeasonPersonPersonable: Personable {
    func map(_ input: CutGraphQL.SeasonPersonFragment) -> Entity {
        let subtitleComponents = input.roles.map { "\($0.role) (\($0.episodeCount) episodes)"}
        return Entity(
            id: input.id,
            title: input.name,
            subtitle: subtitleComponents.joined(separator: ", "),
            imageUrl: input.imageUrl
        )
    }

    func person(_ input: CutGraphQL.SeasonPersonFragment) -> Person {
        input.fragments.personInterfaceFragment
    }
}

struct SeasonPersonEntityMapper: EntityMapper {
    func map(_ input: CutGraphQL.SeasonPersonFragment) -> Entity {
        let subtitleComponents = input.roles.map { "\($0.role) (\($0.episodeCount) episodes)"}
        return Entity(
            id: input.id,
            title: input.name,
            subtitle: subtitleComponents.joined(separator: ", "),
            imageUrl: input.imageUrl
        )
    }

    func presentedView(_ input: CutGraphQL.SeasonPersonFragment) -> some View {
        PersonDetailView(person: input.fragments.personInterfaceFragment)
    }
}

#Preview {
    SeasonDetailView(
        show: Mocks.content,
        season: Mocks.season,
        extendedSeason: Mocks.extendedSeason
    )
}

#Preview {
    SeasonDetailView(
        show: Mocks.content,
        season: Mocks.season
    )
}
