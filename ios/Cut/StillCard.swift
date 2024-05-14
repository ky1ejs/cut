//
//  StillCard.swift
//  Cut
//
//  Created by Kyle Satti on 5/11/24.
//

import SwiftUI
import Kingfisher

struct StillCardEntity {
    let id: String
    let title: String
    let subtitle1: String
    let subtitle2: String
    let imageUrl: URL?
}

struct StillCard: View {
    @Environment(\.theme) var theme
    let entity: StillCardEntity

    var body: some View {
        VStack {
            KFImage(entity.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 230, height: 100)
                .clipped()
            HStack {
                VStack(alignment: .leading) {
                    Text(entity.title)
                        .lineLimit(1)
                        .font(.cut_body)
                        .bold()
                    Text(entity.subtitle1)
                        .lineLimit(1)
                        .font(.cut_subheadline)
                    Text(entity.subtitle2 + "\n\n")
                        .lineLimit(2)
                        .font(.cut_subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundStyle(theme.text.color)
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: 230)
        .background(theme.overlayBackground.color)
        .mask {
            RoundedRectangle(cornerRadius: 15)
        }
    }
}

#Preview {
    VStack {
        ScrollView(.horizontal) {
            LazyHStack {
                let url = URL(string: "https://image.tmdb.org/t/p/original/u90Ryx8OztC5OeVTXHPcZ8fnKoA.jpg")
                StillCard(
                    entity: StillCardEntity(
                        id: "1",
                        title: "Test",
                        subtitle1: "Testy test",
                        subtitle2: "Testy test",
                        imageUrl: url
                    )
                )
                StillCard(
                    entity: StillCardEntity(
                        id: "1",
                        title: "Test",
                        subtitle1: "test",
                        subtitle2: .placeholder(length: 150),
                        imageUrl: url
                    )
                )
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .scrollIndicators(.hidden)
        Spacer()
    }
}
