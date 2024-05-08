//
//  CastCarousel.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import SwiftUI

struct CastCarousel: View {
    let cast: [CutGraphQL.ActorFragment]?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .font(.cut_title1)
            ScrollView(.horizontal) {
                LazyHStack {
                    if let cast = cast {
                        let cardCount = Int(ceil(Double(cast.count) / 4))
                        ForEach(0..<cardCount, id: \.self) { i in
                            PeopleCard(entities: ((i * 4)..<min((i+1)*4, cast.count)).map { i in
                                let p = cast[i]
                                return Entity(id: p.id, title: p.name, subtitle: p.character, imageUrl: p.profile_url)
                            }
                            )
                        }
                    } else {
                        PeopleCard(entities: (0..<4).map {
                            Entity(
                                id: String($0),
                                title: "blah blah blah blah",
                                subtitle: "blah blah blah blah",
                                imageUrl: nil
                            )
                        }
                        )
                        .redacted(reason: .placeholder)
                        .shimmering()
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .scrollIndicators(.never)
        }
    }
}

#Preview {
    CastCarousel(cast: nil)
}
