//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI
import Kingfisher

struct ContentRowViewModel {
    let movie: CutGraphQL.MovieFragment

    var imageUrl: String { return movie.poster_url }
    var title: String { return movie.title }

    var subtitle: String {
        return "\(movie.genres[0]!.metadata.name) • \(movie.metadata.runtime)"
    }
}

struct ContentRow: View {
    let viewModel: ContentRowViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            UrlImage(url: URL(string: viewModel.imageUrl)!)
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

struct UrlImage: View {
    let url: URL

    var body: some View {
        KFImage.url(url)
            .placeholder { Color(.red) }
                  .loadDiskFileSynchronously()
                  .cacheMemoryOnly()
                  .fade(duration: 0.25)
                  .onProgress { receivedSize, totalSize in  }
                  .onFailure { error in }
                  .resizable()
                  .aspectRatio(contentMode: .fit)


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
    let json = """
        {
        "__typename": "Movie",
                "title": "Aquaman and the Lost Kingdom",
                "id": 572802,
                "metadata": {
        "__typename": "MovieMetadata",
                  "runtime": 120
                },
                "release_date": null,
                "poster_url": "https://image.tmdb.org/t/p/w500/7lTnXOy0iNtBAdRP3TZvaKJ77F6.jpg",
                "genres": [
                  {
            "__typename": "Genre",
                    "metadata": {
        "__typename": "GenreMetadata",
                      "name": "Action"
                    }
                  },
                  {
                "__typename": "Genre",
                    "metadata": {
            "__typename": "GenreMetadata",
                      "name": "Adventure"
                    }
                  },
                  {
                "__typename": "Genre",
                    "metadata": {
            "__typename": "GenreMetadata",
                      "name": "Fantasy"
                    }
                  }
                ]
              }
    """
    let jsonObject = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: AnyHashable]
    let movie = try! CutGraphQL.MovieFragment(data: jsonObject)
    let viewModel = ContentRowViewModel(movie: movie)
    return ContentRow(viewModel: viewModel)
}

#Preview {
    return ImageStack(urls: ["test", "rest"])
}
