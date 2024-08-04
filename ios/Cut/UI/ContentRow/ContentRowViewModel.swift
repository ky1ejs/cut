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
    let content: Content

    init(content: Content) {
        self.content = content
    }

    var imageUrl: URL? { content.poster_url }
    var title: String { content.title }

    var subtitle: String? {
        return content.mainGenre?.name ?? content.genres.first?.name
    }
}
