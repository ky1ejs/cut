//
//  EpisodeCarousel.swift
//  Cut
//
//  Created by Kyle Satti on 5/13/24.
//

import SwiftUI

struct EpisodeCarousel: View {
    let episodes: [CutGraphQL.EpisodeFragment]?

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                if let episodes = episodes, episodes.count > 0 {
                    ForEach(episodes, id: \.id) { e in
                        StillCard(entity: StillCardEntity(
                            id: e.id,
                            title: e.name,
                            subtitle1: e.runtime?.runtimeString ?? "",
                            subtitle2: e.overview,
                            imageUrl: e.still_url)
                        )
                    }
                } else if episodes == nil {
                    ForEach(0..<9, id: \.self) { i in
                        StillCard(entity: StillCardEntity(
                            id: String(i),
                            title: .placeholder(length: 10),
                            subtitle1: .placeholder(length: 5),
                            subtitle2: .placeholder(length: 7),
                            imageUrl: nil)
                        )
                    }
                    .redacted(reason: .placeholder)
                    .shimmering()
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .scrollIndicators(.never)
    }
}

#Preview {
    EpisodeCarousel(episodes: nil)
        .background(.black)
}
