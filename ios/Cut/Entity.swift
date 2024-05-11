//
//  Entity.swift
//  Cut
//
//  Created by Kyle Satti on 5/11/24.
//

import Foundation

struct Entity {
    let id: String
    let title: String
    let subtitle: String
    let imageUrl: URL?

    static func from(_ movie: Movie) -> Self {
        let subtitle = [
            movie.mainGenre?.name ?? movie.genres.first?.name,
            movie.releaseDate != nil ? Formatters.yearDF.string(from: movie.releaseDate!) : nil
        ]
            .compactMap { $0 }
            .joined(separator: " • ")
        return Self(
            id: movie.id,
            title: movie.title,
            subtitle: subtitle,
            imageUrl: movie.poster_url
        )
    }

    static func from(_ person: PersonWithRole) -> Self {
        return Entity(
            id: person.id,
            title: person.name,
            subtitle: person.role,
            imageUrl: person.imageUrl
        )
    }
}
