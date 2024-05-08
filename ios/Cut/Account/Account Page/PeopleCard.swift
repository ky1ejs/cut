//
//  PeopleCard.swift
//  Cut
//
//  Created by Kyle Satti on 4/29/24.
//

import SwiftUI
import Kingfisher

struct PeopleCard: View {
    @Environment(\.colorScheme) var colorScheme
    let entities: [Entity]

    var body: some View {
        Table(views: entities.map { CircleImageRow(entity: $0) })
        .frame(width: 280)
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        .background(Theme.for(colorScheme).overlayBackground.color)
        .mask {
            RoundedRectangle(cornerRadius: 15)
        }
    }
}

struct Table<T: View>: View {
    let views: [T]

    var body: some View {
        VStack(alignment:.leading) {
            ForEach(0..<views.count, id: \.self) { i in
                views[i]
                if i < views.count - 1 {
                    Divider()
                }
            }
        }
    }
}

struct RoundedRectImageRow: View {
    let entity: Entity

    var body: some View {
        ImageRow(entity: entity) {
            RoundedRectangle(cornerRadius: 10)
        }
    }
}

struct CircleImageRow: View {
    let entity: Entity

    var body: some View {
        ImageRow(entity: entity) {
            Circle()
        }
    }
}

struct Entity {
    let id: String
    let title: String
    let subtitle: String
    let imageUrl: URL?
}

struct ImageRow<Shape: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let entity: Entity
    let shape: () -> Shape

    var body: some View {
        HStack(spacing: 18) {
            if let url = entity.imageUrl {
                KFImage(url)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .mask {
                        shape()
                            .frame(width: 44, height: 44)
                    }
            } else {
                shape()
                .frame(width: 44, height: 44)
                .foregroundStyle(Theme.for(colorScheme).imagePlaceholder.color)
            }
            VStack(alignment: .leading) {
                Text(entity.title)
                Text(entity.subtitle)
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        PeopleCard(entities: (0..<4).map { i in
            Entity(
                id: "1234",
                title: "James Bacarach",
                subtitle: "Top Singer",
                imageUrl: URL(string: "https://image.tmdb.org/t/p/original/hsaZMAXFMS5Iazdslkf06RkJfci.jpg")!
            )
        })
    }
}

#Preview {
    VStack(alignment: .leading) {
        PeopleCard(entities: (0..<4).map { i in
            Entity(
                id: "1234",
                title: "James Bacarach",
                subtitle: "Top Singer",
                imageUrl: nil
            )
        })
    }
}
