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
    let index: Int?

    init(movie: CutGraphQL.MovieFragment, index: Int? = nil) {
        self.movie = movie
        self.index = index
    }

    var imageUrl: String { return movie.poster_url }
    var title: String { return movie.title }

    var subtitle: String {
        return movie.mainGenre?.name ?? ""
    }
}
