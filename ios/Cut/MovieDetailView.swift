//
//  MovieDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 2/23/24.
//

import SwiftUI
import Apollo

struct MovieDetailView: View {
    let movie: Movie
    let extendedMovie: CutGraphQL.ExtendedMovieFragment?

    var body: some View {
        DetailViewContainer(content: movie) { width in
            ContentHeader(content: movie, tvShow: nil, movie: extendedMovie, width: width)
            WhereToWatchCarousel(watchProviders: extendedMovie?.watchProviders.map { $0.fragments.watchProviderFragment })
            CastCarousel(
                cast: extendedMovie?.cast.map { $0.fragments.personFragment },
                crew: extendedMovie?.crew.map { $0.fragments.personFragment }
            )
        }
    }
}

#Preview {
    MovieDetailView(movie: Mocks.movie, extendedMovie: nil)
}
