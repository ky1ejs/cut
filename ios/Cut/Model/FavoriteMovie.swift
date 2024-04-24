//
//  FavoriteMovie.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import Foundation

protocol FavoriteMovie: Equatable {
    var title: String { get }
    var url: String { get }
    var id: String { get }
    var allIds: [String] { get }
    var poster_url: String { get }
}

extension FavoriteMovie {
    var parsedPosterUrl: URL { URL(string: poster_url)! }
}

extension CutGraphQL.FavoriteMovieFragment: FavoriteMovie {}
extension CutGraphQL.MovieFragment: FavoriteMovie {
    var allIds: [String] {
        return [id]
    }
}
