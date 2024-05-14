//
//  PersonCard.swift
//  Cut
//
//  Created by Kyle Satti on 4/29/24.
//

import SwiftUI
import Kingfisher

struct PersonCard: View {
    @Environment(\.theme) var theme
    let title: String?
    let entities: [Entity]
    let entityTapped: ((Int) -> Void)?
    let moreAction: (() -> Void)?

    init(title: String?, entities: [Entity], entityTapped: ((Int) -> Void)? = nil, moreAction: (() -> Void)? = nil) {
        self.title = title
        self.entities = entities
        self.entityTapped = entityTapped
        self.moreAction = moreAction
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading) {
                if let title = title {
                    Text(title)
                        .font(.cut_title2)
                        .foregroundStyle(theme.text.color)
                }
                Table(
                    views: (0..<min(4, entities.count)).map { i in
                        Button(action: { entityTapped?(i)}, label: {
                            CircleImageRow(entity: entities[i])
                        })
                    }
                )
                .frame(width: 280)
            }
            if entities.count > 4 {
                Button("more") {
                    moreAction?()
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 18)
        .padding(.bottom, 12)
        .background(theme.overlayBackground.color)
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

struct ImageRow<Shape: View>: View {
    @Environment(\.theme) var theme
    let entity: Entity
    let shape: () -> Shape

    var body: some View {
        HStack(spacing: 18) {
            if let url = entity.imageUrl {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .mask {
                        shape()
                            .frame(width: 44, height: 44)
                    }
            } else {
                shape()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(theme.imagePlaceholder.color)
            }
            VStack(alignment: .leading) {
                Text(entity.title)
                    .foregroundStyle(theme.text.color)
                Text(entity.subtitle)
                    .font(.cut_footnote)
                    .foregroundStyle(theme.subtitle.color)
            }
            Spacer()
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        PersonCard(
            title: "Title",
            entities: (0..<5).map { i in
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
        PersonCard(
            title: "Title",
            entities: (0..<4).map { i in
                Entity(
                    id: "1234",
                    title: "James Bacarach",
                    subtitle: "Top Singer",
                    imageUrl: nil
                )
            })
    }
}

#Preview {
    VStack(alignment: .leading) {
        PersonCard(
            title: "Title",
            entities: [
                Entity(
                    id: "1234",
                    title: "James Bacarach",
                    subtitle: "Top Singer",
                    imageUrl: nil
                )
            ])
    }
}
