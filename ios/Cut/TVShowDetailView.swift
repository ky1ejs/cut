//
//  TVShowDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 4/28/24.
//

import SwiftUI
import Kingfisher

struct TVShowDetailView: View {
    @Environment(\.theme) var theme
    @State var isExpanded = false
    let content: Content
    let tvShow: CutGraphQL.ExtendedTVShowFragment?
    @State var previewSeason = 1
    @State var season: CutGraphQL.ExtendedSeasonFragment?
    @State var showSeasonPicker = false

    func seasonSubtitle(_ season: CutGraphQL.ExtendedTVShowFragment.Season) -> String {
        if case .some(let date) = season.air_date {
            return Formatters.fullDF.string(from: date)
        }
        return "Un-aired"
    }

    var body: some View {
        ContentDetailViewContainer(content: content) { width in
            ContentHeader(content: content, tvShow: tvShow, movie: nil, width: width)
            HStack {
                if let seasonCount = tvShow?.seasonCount {
                    Button {
                        showSeasonPicker = true
                    } label: {
                        Text(String("Season \(previewSeason) ˅"))
                            .font(.cut_title1)
                            .foregroundStyle(theme.text.color)
                    }
                    .popover(isPresented: $showSeasonPicker, attachmentAnchor: .point(.trailing), content: {
                        VStack {
                            ForEach(1...seasonCount, id: \.self) { i in
                                Button {
                                    previewSeason = i
                                    season = nil
                                    reloadSeason()
                                    showSeasonPicker = false
                                } label: {
                                    Text("Season \(i)")
                                }
                                if i < seasonCount {
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    })
                } else {
                    Text(String.placeholder(length: 10))
                        .font(.cut_title1)
                        .redacted(reason: .placeholder)
                        .shimmering()
                        .foregroundStyle(theme.text.color)
                }
                Spacer()
            }
            EpisodeCarousel(
                seriesId: content.id,
                episodes: season?.episodes.map { $0.fragments.episodeFragment }
            )
            seasons()
            WhereToWatchCarousel(watchProviders: tvShow?.watchProviders.map { $0.fragments.watchProviderFragment })
            CastCarousel(
                cast: tvShow?.cast.map { $0.fragments.personFragment },
                crew: tvShow?.crew.map { $0.fragments.personFragment },
                mapper: PersonPersonable(),
                tableMapper: PersonEntityMapper()
            )
        }
        .animation(.linear(duration: 0.4), value: season)
        .onAppear {
            reloadSeason()
        }
    }

    func reloadSeason() {
        AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetSeasonQuery(seriesId: content.id, seasonNumber: previewSeason)) { result in
            switch result.parseGraphQL() {
            case .success(let data):
                season = data.season.fragments.extendedSeasonFragment
            case .failure(let error):
                print(error)
            }
        }
    }

    func seasons() -> some View {
        VStack(alignment: .leading) {
            Text("Seasons")
                .font(.cut_title1)
                .foregroundStyle(theme.text.color)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    if let tvShow {
                        ForEach(tvShow.seasons, id: \.id) { season in
                            NavigationLink {
                                SeasonDetailView(
                                    show: content,
                                    season: season.fragments.seasonFragment
                                )
                            } label: {
                                VStack {
                                    URLImage(url: season.poster_url)
                                        .frame(width: 80, height: 80 * 1.62)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 10)
                                                .background(theme.background.color)
                                        }
                                    VStack(alignment: .center) {
                                        Text("Season \(season.season_number)")
                                        Text(seasonSubtitle(season))
                                            .font(.cut_caption2)
                                            .foregroundStyle(theme.subtitle.color)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.bottom, 6)
                                }
                            }
                        }
                    } else {
                        ForEach(0..<8, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(theme.redactionBackground.color)
                                .frame(width: 80, height: 80 * 1.62)
                                .shimmering(gradient: theme.skeletonGradient, bandSize: 0.4)
                        }
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .scrollIndicators(.never)
        }
    }
}

struct CircleButton: View {
    @Environment(\.colorScheme) var colorScheme
    let kind: Kind
    let action: () -> Void
    enum Kind {
        case watchListAdd, watched, share

        var image: Image {
            switch self {
            case .watchListAdd:
                Image("plus")
            case .watched:
                Image("eye")
            case .share:
                Image("paper_airplane")
            }
        }
    }

    var body: some View {
        Button(action: action) {
            kind.image
                .colorMultiply(UIColor.gray05.color)
        }.buttonStyle(CircleButtonStyle())
    }
}

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let t = Theme.current
        ZStack {
            Circle()
                .foregroundStyle(configuration.isPressed ? t.subtitle.color : t.lightgray.color )
                .frame(width: 50, height: 50)
            configuration.label
        }
    }
}


func round(_ num: Double, to places: Int) -> Double {
    let p = log10(abs(num))
    let f = pow(10, p.rounded() - Double(places) + 1)
    let rnum = (num / f).rounded() * f

    return rnum
}

extension CutGraphQL.AccessModel {
    var displayName: String {
        switch self {
        case .buy:
            return "Buy"
        case .rent:
            return "Rent"
        case .stream:
            return "Stream"
        }
    }
}

#Preview {
    TVShowDetailView(content: Mocks.content, tvShow: nil)
}

#Preview {
    NavigationStack {
        TVShowDetailView(content: Mocks.content, tvShow: Mocks.extendedTvShow)
    }
}
