//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

struct ContentRow: View {
    let viewModel: ContentRowViewModel
    @State var watchListViewModel: WatchListViewModel
    let index: Int?

    init(viewModel: ContentRowViewModel, index: Int? = nil) {
        self.viewModel = viewModel
        self.watchListViewModel = WatchListViewModel(movie: viewModel.movie, index: index)
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
                Text(viewModel.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.sub)
            }
            Spacer()
            WatchListButton(isOnWatchList: watchListViewModel.isOnWatchList) {
                watchListViewModel.toggleWatchList()
            }
        }
        .padding(0)
    }
}

#Preview {
    let viewModel = ContentRowViewModel(movie: Mocks.movie)
    return ContentRow(viewModel: viewModel, index: 0)
}
