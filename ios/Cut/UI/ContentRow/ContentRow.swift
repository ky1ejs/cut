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
            URLImage(url: URL(string: viewModel.imageUrl)!)
                .foregroundStyle(.red)
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .font(.title3)
                if let subtitle = viewModel.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.sub)
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

extension ContentRow where Accessory == WatchListButton {
    init(viewModel: ContentRowViewModel, index: Int? = nil) {
        self.viewModel = viewModel
        self.accessory = WatchListButton(movie: viewModel.movie, index: index)
        self.index = index
    }
}

struct StatedContentRow: View {
    var movie: Movie
    @State var isIncluded: Bool
    let action: (() -> Void?)

    var body: some View {
        ContentRow(viewModel: ContentRowViewModel(movie: movie), accessory: Button(isIncluded ? "Remove" : "Add") {
            isIncluded.toggle()
            action()
        })
    }
}

class ContentRowCell: UITableViewCell {
    var action: (() -> Void)?
    private var content: UIHostingConfiguration<ContentRow<Button<Text>>, EmptyView>?

    func update(movie: Movie, isIncluded: Bool) {
        let content = UIHostingConfiguration {
            StatedContentRow(movie: movie, isIncluded: isIncluded) {
                self.action?()
            }
        }
        contentConfiguration = content
    }
}

#Preview {
    let viewModel = ContentRowViewModel(movie: Mocks.movie)
    return ContentRow(viewModel: viewModel)
}
