//
//  MovieDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 2/23/24.
//

import SwiftUI
import Apollo

struct MovieDetailView: View {
    let content: Content
    let extendedMovie: CutGraphQL.ExtendedMovieFragment?

    var body: some View {
        ContentDetailViewContainer(content: content) { width in
            ContentHeader(content: content, tvShow: nil, movie: extendedMovie, width: width)
            WhereToWatchCarousel(watchProviders: extendedMovie?.watchProviders.map { $0.fragments.watchProviderFragment })
            CastCarousel(
                cast: extendedMovie?.cast.map { $0.fragments.personFragment },
                crew: extendedMovie?.crew.map { $0.fragments.personFragment },
                mapper: PersonPersonable(),
                tableMapper: PersonEntityMapper()
            )
        }
    }
}

#Preview {
    MovieDetailView(content: Mocks.content, extendedMovie: nil)
}
