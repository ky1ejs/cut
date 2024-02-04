//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI

protocol ImageLoader {
    func loadImage(_ url: String) async -> UIImage
}

struct ContentRowViewModel {
    private let imageLoader: ImageLoader
    let movie: Movie

    var imageUrl: String { return movie.imageUrl }
    var title: String { return movie.title }
    var year: String { return movie.year }
    var genre: String { return movie.genre }
    var duration: String { return movie.duration }

    var subtitle: String {
        return "\(year) • \(genre) • \(duration)"
    }

    init(imageLoader: ImageLoader, movie: Movie) {
        self.imageLoader = imageLoader
        self.movie = movie
    }

    func image() async -> UIImage {
        return await imageLoader.loadImage(imageUrl)
    }
}

struct ContentRow: View {
    let viewModel: ContentRowViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
                Rectangle()
                    .foregroundStyle(.red)
                    .frame(height: 150)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    ImageStack(urls: ["a", "b", "c"])
                    Text("Fabiano & 6 others like this").font(.footnote)
                }
                Text(viewModel.title)
                    .font(.title2)
                Text(viewModel.subtitle)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(0)
    }
}

struct FakeImageLoader: ImageLoader {
    func loadImage(_ url: String) async -> UIImage {
        return UIImage()
    }
}

struct ImageStack: View {
    let urls: [String]
    private let spacing: CGFloat = 4

    var body: some View {
        HStack(spacing: -spacing) {
            ForEach(0..<urls.count, id: \.self) { i in
                if i < urls.count - 1 {
                    Circle()
                        .foregroundColor(.red)
                        .mask(MoonMask(amount: spacing).fill(style: FillStyle(eoFill: true)))
                } else {
                    Circle()
                        .foregroundColor(.red)
                }
            }
        }
        .frame(maxHeight: spacing * 4)
    }
}

struct MoonMask: Shape {
    let amount: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        path.addPath(Circle().path(in: rect)
            .offsetBy(dx: amount * 2.4, dy: 0))
        return path
    }
}


#Preview {
    let movie = Movie(id: "1", imageUrl: "test", title: "Dune", year: "2021", genre: "Sci-fi", duration: "1hr 20mins")
    let viewModel = ContentRowViewModel(
        imageLoader: FakeImageLoader(),
        movie: movie
    )
    return ContentRow(viewModel: viewModel)
}

#Preview {
    return ImageStack(urls: ["test", "rest"])
}
