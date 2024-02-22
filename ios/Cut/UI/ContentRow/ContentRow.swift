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
    let json = """
        {
          "__typename": "Movie",
          "title": "The Godfather",
          "id": "1e42a292-91c9-447a-adf5-2e3d7811e405",
          "poster_url": "https://image.tmdb.org/t/p/original/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
          "release_date": "Mon Mar 13 1972 19:00:00 GMT-0500 (Eastern Standard Time)",
          "mainGenre": null,
          "genres": [
            {
              "__typename": "Genre",
              "name": "War",
              "id": 18
            }
          ],
          "isOnWatchList": true
        }
    """
    let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
    let movie = try! CutGraphQL.MovieFragment(data: jsonObject)
    let viewModel = ContentRowViewModel(movie: movie)
    return ContentRow(viewModel: viewModel, index: 0)
}
