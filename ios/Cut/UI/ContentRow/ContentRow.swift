//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

struct ContentRow: View {
    var viewModel: ContentRowViewModel
    let index: Int?

    init(viewModel: ContentRowViewModel, index: Int? = nil) {
        self.viewModel = viewModel
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
                    .font(.cutTitle)
                Text(viewModel.subtitle)
                    .font(.cutSubtitle)
                    .foregroundStyle(Color.sub)
            }
            Spacer()
            WatchListButton(isOnWatchList: viewModel.isOnWatchList) {
                viewModel.toggleWatchList()
            }
        }
        .padding(0)
    }
}

#Preview {
    let viewModel = ContentRowViewModel(movie: Mocks.movie)
    return ContentRow(viewModel: viewModel, index: 0)
}
