//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

struct ContentRow<Accessory: View>: View {
    let content: Content
    let accessory: Accessory?

    init(content: Content, accessory: Accessory?) {
        self.content = content
        self.accessory = accessory
    }

    var body: some View {
        EntityRow(
            entity: Entity.from(content),
            accessory: accessory
        )
    }
}

extension ContentRow where Accessory == SmallWatchListButton {
    init(content: Content, index: Int? = nil) {
        self.content = content
        self.accessory = SmallWatchListButton(content: content, index: index)
    }
}

struct EntityRow<Accessory: View>: View {
    @Environment(\.theme) var theme
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
    func set(_ content: Content) {
        let content = UIHostingConfiguration {
            EntityRow(entity: Entity.from(content))
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
    return ContentRow(content: Mocks.content)
}
