//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

struct ContentRow<Accessory: View>: View {
    let movie: Movie
    let accessory: Accessory?

    init(movie: Movie, accessory: Accessory?) {
        self.movie = movie
        self.accessory = accessory
    }

    var body: some View {
        EntityRow(
            entity: Entity.from(movie),
            accessory: accessory
        )
    }
}

extension ContentRow where Accessory == SmallWatchListButton {
    init(movie: Movie, index: Int? = nil) {
        self.movie = movie
        self.accessory = SmallWatchListButton(movie: movie, index: index)
    }
}

struct EntityRow<Accessory: View>: View, Themed {
    @Environment(\.colorScheme) var colorScheme
    let entity: Entity
    let accessory: Accessory?

    init(entity: Entity, accessory: Accessory) {
        self.entity = entity
        self.accessory = accessory
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            URLImage(url: entity.imageUrl)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            VStack(alignment: .leading, spacing: 6) {
                Text(entity.title)
                    .font(.title3)
                Text(entity.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(theme.subtitle.color)
            }
            Spacer()
            accessory
        }
        .padding(0)
    }
}

extension EntityRow where Accessory == EmptyView {
    init(entity: Entity, accessory: Accessory? = nil) {
        self.entity = entity
        self.accessory = accessory
    }
}

class EntityRowCell: UITableViewCell {
    func set(_ movie: Movie) {
        let content = UIHostingConfiguration {
            EntityRow(entity: Entity.from(movie))
        }
        contentConfiguration = content
    }
}




#Preview {
    return EntityRow(
        entity: Entity(
            id: "123",
            title: "123",
            subtitle: "123",
            imageUrl: nil
        )
    )
}

#Preview {
    return ContentRow(movie: Mocks.movie)
}
