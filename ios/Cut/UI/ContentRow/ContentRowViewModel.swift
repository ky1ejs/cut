//
//  ContentRowViewModel.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI
import Apollo
import ApolloAPI

class ContentRowViewModel: ObservableObject {
    let movie: CutGraphQL.MovieFragment

    init(movie: CutGraphQL.MovieFragment) {
        self.movie = movie
    }

    var imageUrl: URL? { movie.poster_url }
    var title: String { movie.title }

    var subtitle: String? {
        return movie.mainGenre?.name ?? movie.genres.first?.name
    }
}
