//
//  CoverShelf.swift
//  Cut
//
//  Created by Kyle Satti on 3/26/24.
//

import SwiftUI

struct CoverShelf: View {
    let posters: [URL]

    var body: some View {
        HStack {
            ForEach(posters, id: \.absoluteString) { p in
                URLImage(url: p)
            }
            if posters.count < 5 {
                ForEach(0..<5 - posters.count, id: \.self) { _ in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1.0)
                            .background(.clear)
                            .aspectRatio(0.66, contentMode: .fit)
                        Image(systemName: "plus")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    let url = URL(string: Mocks.movie.poster_url)!
    return CoverShelf(posters: [url, url])
        .padding(.horizontal, 12)
}
