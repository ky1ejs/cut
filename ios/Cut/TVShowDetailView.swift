//
//  TVShowDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 4/28/24.
//

import SwiftUI
import Kingfisher

struct TVShowDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var isExpanded = false
    let movie: Movie
    let tvShow: CutGraphQL.ExtendedTVShowFragment?
    private var theme: Themeable { Theme.for(colorScheme) }

    func seasonSubtitle(_ season: CutGraphQL.ExtendedTVShowFragment.Season) -> String {
        if case .some(let date) = season.air_date {
            return Formatters.fullDF.string(from: date)
        }
        return "Un-aired"
    }

    var body: some View {
        DetailViewContainer(content: movie) { width in
            ContentHeader(content: movie, tvShow: tvShow, movie: nil, width: width)
            seasons()
            WhereToWatchCarousel(watchProviders: tvShow?.watchProviders.map { $0.fragments.watchProviderFragment })
            CastCarousel(
                cast: tvShow?.cast.map { $0.fragments.personFragment },
                crew: tvShow?.crew.map { $0.fragments.personFragment }
            )
        }
    }

    func seasons() -> some View {
        VStack(alignment: .leading) {
            Text("Seasons")
                .font(.cut_title1)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    if let tvShow {
                        ForEach(tvShow.seasons, id: \.id) { season in
                            VStack {
                                URLImage(url: season.poster_url)
                                    .frame(width: 80, height: 80 * 1.62)
                                    .mask {
                                        RoundedRectangle(cornerRadius: 10)
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
    TVShowDetailView(movie: Mocks.movie, tvShow: nil)
}
