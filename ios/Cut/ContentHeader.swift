//
//  ContentHeader.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import SwiftUI
import Kingfisher

struct ContentHeader: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Movie
    let tvShow: CutGraphQL.ExtendedTVShowFragment?
    let movie: CutGraphQL.ExtendedMovieFragment?
    let width: CGFloat
    var theme: Themeable { Theme.for(colorScheme) }
    var isLoading: Bool { tvShow == nil && movie == nil }
    var extendedContent: CutGraphQL.ExtendedContentFragment? {
        tvShow?.fragments.extendedContentFragment ?? movie?.fragments.extendedContentFragment
    }
    @State var isExpanded = false

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
            let hours = movie.runtime / 60
            let remainingMinutes = movie.runtime % 60

            if hours == 0 {
                subtitleArray.append("\(remainingMinutes)min")
            } else if remainingMinutes == 0 {
                subtitleArray.append("\(hours)h")
            } else {
                subtitleArray.append("\(hours)h \(remainingMinutes)min")
            }
        }

        return subtitleArray.joined(separator: " • ")
    }

    var body: some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<5, id: \.self) { i in
                        VStack {
                            KFImage(content.poster_url)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .mask {
                                    RoundedRectangle(cornerRadius: 10)
                                }
                        }
                        .frame(width: max(width - 40, 0), height: 260)
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
            HStack(spacing: 16) {
                //                                HStack(spacing: 4) {
                //                                    ImageStack(urls: ["https://image.tmdb.org/t/p/original/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg", "https://image.tmdb.org/t/p/original/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg", "https://image.tmdb.org/t/p/original/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg"])
                //                                        .fixedSize(horizontal: false, vertical: true)
                //                                    Text("9.9")
                //                                }
                if let tvShow = tvShow {
                    rating(tvShow.userRating)
                }
                if let movie = movie {
                    rating(movie.userRating)
                }
            }
        }
        VStack(spacing: 0) {
            Text(extendedContent?.overview ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod ultricies orci non fringilla. Vestibulum efficitur semper nisi, ac vehicula magna laoreet ac. Integer eu dapibus nunc. Duis et urna nec purus tempor sollicitudin. Quisque vitae sagittis purus, ut tincidunt enim. Proin vitae purus ligula. Sed vehicula velit non lacinia lobortis. Nullam vitae purus eu justo placerat convallis. Sed pretium justo nisi, vitae scelerisque risus tempus in. Sed ac leo neque. Sed et pulvinar justo. Maecenas non orci vitae purus mattis efficitur eget a nisi. Nunc tempus, dolor id molestie ultricies, elit elit fringilla sapien, vel accumsan felis velit at sapien. Suspendisse potenti.")
                .frame(maxHeight: isExpanded ? nil : 100)
                .multilineTextAlignment(.center)
                .redacted(reason: isLoading ? .placeholder : [])
                .shimmering(active: isLoading)
            Button(isExpanded ? "less..." : "more...") {
                isExpanded.toggle()
            }
            .redacted(reason: isLoading ? .placeholder : [])
            .disabled(isLoading)
            .shimmering(active: isLoading, bandSize: 0.6)
        }
        .animation(.default, value: isExpanded)
    }

    private func rating(_ rating: Double) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
            Text(Formatters.twoFractionDigits.string(from: NSNumber(floatLiteral: rating * 10))!)
        }
    }
}

#Preview {
    GeometryReader { proxy in
        VStack {
            ContentHeader(content: Mocks.movie, tvShow: nil, movie: nil, width: proxy.size.width)
        }
        .safeAreaPadding(.horizontal, 20)
    }
}
