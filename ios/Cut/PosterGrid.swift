//
//  PosterGrid.swift
//  Cut
//
//  Created by Kyle Satti on 3/31/24.
//

import SwiftUI

struct PosterGrid: View {
    let movies: [Movie]

    var body: some View {
        if movies.count > 0 {
            ScrollView {
                LazyVGrid(
                    columns: Array(
                        repeating: .init(.flexible(minimum: 100), spacing: 0),
                        count: 3
                    ),
                    spacing: 0
                ) {
                    ForEach(movies, id: \.id) { movie in
                        PosterCell(url: movie.poster_url)
                    }
                }
            }
        } else {
            Text("nothing to see here")
                .font(.cut_title2)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    PosterGrid(
        movies: (0..<15).map { _ in  Mocks.movie }
    )
}
