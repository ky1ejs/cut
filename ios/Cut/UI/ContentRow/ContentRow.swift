//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

struct ContentRow<Accessory: View>: View {
    let viewModel: ContentRowViewModel
    let index: Int?
    let accessory: Accessory?

    init(viewModel: ContentRowViewModel, accessory: Accessory, index: Int? = nil) {
        self.viewModel = viewModel
        self.accessory = accessory
        self.index = index
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            URLImage(url: viewModel.imageUrl)
                .foregroundStyle(.red)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .font(.title3)
                if let subtitle = viewModel.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.cut_sub)
                }
            }
            Spacer()
            accessory
        }
        .padding(0)
    }
}

extension ContentRow where Accessory == EmptyView {
    init(viewModel: ContentRowViewModel, accessory: Accessory? = nil, index: Int? = nil) {
        self.viewModel = viewModel
        self.accessory = accessory
        self.index = index
    }
}

extension ContentRow where Accessory == SmallWatchListButton {
    init(viewModel: ContentRowViewModel, index: Int? = nil) {
        self.viewModel = viewModel
        self.accessory = SmallWatchListButton(movie: viewModel.movie, index: index)
        self.index = index
    }
}

class ContentRowCell: UITableViewCell {
    func set(_ movie: Movie) {
        let content = UIHostingConfiguration {
            ContentRow(viewModel: ContentRowViewModel(movie: movie), accessory: nil)
        }
        contentConfiguration = content
    }
}

#Preview {
    let viewModel = ContentRowViewModel(movie: Mocks.movie)
    return ContentRow(viewModel: viewModel)
}
