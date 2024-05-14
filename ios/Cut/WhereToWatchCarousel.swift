//
//  WhereToWatchCarousel.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import SwiftUI

struct WhereToWatchCarousel: View {
    @Environment(\.theme) var theme
    let watchProviders: [CutGraphQL.WatchProviderFragment]?

    var body: some View {
        if let watchProviders = watchProviders {
            HStack {
                VStack(alignment: .leading) {
                    Text("Where to Watch")
                        .font(.cut_title1)
                        .foregroundStyle(theme.text.color)
                    if !watchProviders.isEmpty {
                        Table(views: (watchProviders).map { i in
                            RoundedRectImageRow(
                                entity: Entity(
                                    id: String(i.provider_id),
                                    title: i.provider_name,
                                    subtitle: i.accessModels.map { $0.value?.displayName ?? "" }.joined(separator: ", "),
                                    imageUrl: i.logo_url))
                        })
                    } else {
                        Text("Not available yet.")
                            .foregroundStyle(theme.subtitle.color)
                    }

                }
                Spacer()
            }
        } else {
            VStack(alignment: .leading) {
                Text("Where to Watch")
                    .font(.cut_title1)
                    .foregroundStyle(theme.text.color)
                    .redacted(reason: .placeholder)
                    .shimmering()
                Table(views: (0..<5).map { i in
                    RoundedRectImageRow(
                        entity: Entity(
                            id: String(i),
                            title: "blah blah blah",
                            subtitle: "blah blah blah",
                            imageUrl: nil))
                    .redacted(reason: .placeholder)
                    .shimmering()

                })
            }
        }
    }
}

#Preview {
    WhereToWatchCarousel(watchProviders: nil)
        .background(.black)
}

#Preview {
    WhereToWatchCarousel(watchProviders: [])
}
