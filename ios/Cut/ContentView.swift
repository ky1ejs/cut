//
//  ContentView.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

struct ImageLoaderImpl: ImageLoader {
    func loadImage(_ url: String) async -> UIImage {
        return UIImage()
    }
}

struct Movie {
    let id: String
    let imageUrl: String
    let title: String
    let year: String
    let genre: String
    let duration: String
}

struct ContentView: View {
    let rows: [Movie]

    init() {
        rows = (0..<8).map({ id in
            Movie(id: "\(id)", imageUrl: "", title: "test", year: "2010", genre: "action", duration: "1hr 22min")
        })
    }

    var body: some View {
        List {
            ForEach(rows, id: \.id) { m in
                ContentRow(viewModel: ContentRowViewModel(imageLoader: ImageLoaderImpl(), movie: m))
            }
        }.listStyle(.plain)
    }
}

#Preview {
    ContentView()
}
