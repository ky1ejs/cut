//
//  PosterCell.swift
//  Cut
//
//  Created by Kyle Satti on 3/31/24.
//

import SwiftUI

struct PosterCell: View {
    let url: String

    var body: some View {
        URLImage(url)
            .clipped()
            .aspectRatio(0.5, contentMode: .fill)
    }
}

#Preview {
    PosterCell(url: "https://image.tmdb.org/t/p/original/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg")
}
