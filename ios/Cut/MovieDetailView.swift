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
            CastCarousel(cast: extendedMovie?.cast.map { $0.fragments.actorFragment })
        }
    }
}

extension CutGraphQL.PersonRole {
    var name: String {
        switch self {
        case .director:
            return "Director"
        case .executiveProducer:
            return "Executive Producer"
        case .producer:
            return "Producer"
        case .writer:
            return "Writer"
        }
    }
}

#Preview {
    MovieDetailView(movie: Mocks.movie, extendedMovie: nil)
}
