//
//  ContentHeader.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import SwiftUI
import Kingfisher
import UIKit
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView()
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ContentHeader: View {
    @Environment(\.theme) var theme
    @Environment(\.openURL) private var openURL
    let content: Content
    let tvShow: CutGraphQL.ExtendedTVShowFragment?
    let movie: CutGraphQL.ExtendedMovieFragment?
    let width: CGFloat
    var isLoading: Bool { tvShow == nil && movie == nil }
    var extendedContent: CutGraphQL.ExtendedContentInterfaceFragment? {
        tvShow?.fragments.extendedContentInterfaceFragment ?? movie?.fragments.extendedContentInterfaceFragment
    }

    var subtitle: String {
        var subtitleArray = [String]()
        if let release_date = content.releaseDate {
            let string = Formatters.yearDF.string(from: release_date)
            subtitleArray.append(string)
        }
        if let genre = content.mainGenre?.name ?? content.genres.first?.name {
            subtitleArray.append(genre)
        }

        if let tvShow = tvShow {
            let season = "\(tvShow.seasons.count) season\(tvShow.seasons.count > 1 ? "s" : "")"
            subtitleArray.append(season)
        }

        if let movie = movie {
            subtitleArray.append(movie.runtime.runtimeString)
        }

        return subtitleArray.joined(separator: " • ")
    }

    var body: some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal) {
                LazyHStack {
                    VStack {
                        KFImage(content.poster_url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .mask {
                                RoundedRectangle(cornerRadius: 10)
                            }
                    }
                    .frame(width: max(width - 40, 0), height: 260)
                    if let trailer = extendedContent?.trailer {
                        Button(action: {
                            openURL(trailer.url)
                        }, label: {
                            ZStack {
                                KFImage(trailer.thumbnail_url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .mask {
                                        RoundedRectangle(cornerRadius: 10)
                                    }
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(12)
                                    .background {
                                        VisualEffectView(effect: UIBlurEffect(style: .light))
                                    }
                                    .mask {
                                        RoundedRectangle(cornerRadius: 12)
                                    }
                                    .tint(.black)
                            }
                            .frame(width: max(width - 40, 0), height: 260)
                        })
                    }
                }
                .scrollTargetLayout()
            }
            .fixedSize(horizontal: false, vertical: true)
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
            .scrollIndicators(.never)
            Text(subtitle)
                .font(.cut_caption1)
                .foregroundStyle(isLoading ? theme.redactionForeground.color : theme.subtitle.color)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
            Text(content.title)
                .font(.cut_largeTitle)
                .foregroundColor(theme.text.color)
            HStack(spacing: 16) {
                if let tvShow = tvShow {
                    rating(tvShow.userRating)
                }
                if let movie = movie {
                    rating(movie.userRating)
                }
                if let rating = content.rating {
                    HStack {
                        Image(rating > 3 ? "gold_rating" : "silver_rating")
                            .resizable()
                            .frame(width: 16, height: 18.3333333333)
                        Text("\(rating)/5")
                            .foregroundStyle(.white)
                    }
                }
            }
            LongText(extendedContent?.overview ?? .placeholder(length: 300))
                .foregroundColor(theme.text.color)
                .multilineTextAlignment(.center)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
        }
    }

    private func rating(_ rating: Double) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(theme.text.color)
            Text(Formatters.twoFractionDigits.string(from: NSNumber(floatLiteral: rating * 10))!)
                .foregroundStyle(theme.text.color)
        }
    }
}

#Preview {
    GeometryReader { proxy in
        VStack {
            ContentHeader(content: Mocks.content, tvShow: nil, movie: nil, width: proxy.size.width)
                .background(.black)
        }
        .safeAreaPadding(.horizontal, 20)
    }
}

#Preview {
    GeometryReader { proxy in
        VStack {
            ContentHeader(content: Mocks.content, tvShow: Mocks.extendedTvShow, movie: nil, width: proxy.size.width)
        }
        .safeAreaPadding(.horizontal, 20)
        .backgroundStyle(.black)
    }
}
