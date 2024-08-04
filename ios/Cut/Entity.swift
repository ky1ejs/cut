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

    static func from(_ content: Content) -> Self {
        let subtitle = [
            content.mainGenre?.name ?? content.genres.first?.name,
            content.releaseDate != nil ? Formatters.yearDF.string(from: content.releaseDate!) : nil
        ]
            .compactMap { $0 }
            .joined(separator: " • ")
        return Self(
            id: content.id,
            title: content.title,
            subtitle: subtitle,
            imageUrl: content.poster_url
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
