//
//  ContentRow.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI
import Kingfisher
import Apollo

extension Font {
    static var cutTitle: Font {
        Font.system(size: 18, weight: .bold, design: .rounded)
    }

    static var cutSubtitle: Font {
        Font.system(size: 13, weight: .semibold, design: .rounded)
    }
}

extension Color {
    static var sub: Color {
        return Color(white: 0, opacity: 0.2)
    }
}

struct ContentRowViewModel {
    let movie: CutGraphQL.MovieFragment

    var imageUrl: String { return movie.poster_url }
    var title: String { return movie.title }

    var subtitle: String {
        return movie.mainGenre?.name ?? ""
    }
}

class WatchListButtonViewModel: ObservableObject {
    @Published var isOnWatchList: Bool
    private let movieId: String
    private var currentRequest: Apollo.Cancellable?

    init(isOnWatchList: Bool, movieId: String) {
        self.isOnWatchList = isOnWatchList
        self.movieId = movieId
    }

    func watchListToggle() {
        let original = isOnWatchList
        isOnWatchList = !isOnWatchList
        currentRequest?.cancel()
        if original {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.RemoveFromWatchListMutation(movieId: movieId)) { [weak self] result in
                    if case .failure = result {
                        self?.isOnWatchList = original
                    }
                }
        } else {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.AddToWatchListMutation(movieId: movieId)) { [weak self] result in
                    if case .failure = result {
                        self?.isOnWatchList = original
                    }
                }
        }
    }
}

struct WatchListButton: View {
    @ObservedObject var viewModel: WatchListButtonViewModel

    var body: some View {
        Button(action: {
            viewModel.watchListToggle()
        }, label: {
            label()
        })
        .frame(width: 36, height: 36)
        .background(Circle().foregroundStyle(viewModel.isOnWatchList ? Color.black : Color.sub))
    }

    func label() -> some View {
        let image: UIImage = viewModel.isOnWatchList ? .init(named: "check")! : .init(named: "plus")!
        return Image(uiImage: image)
            .tint(viewModel.isOnWatchList ? .black : .white)
    }
}

struct ContentRow: View {
    let viewModel: ContentRowViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            UrlImage(url: URL(string: viewModel.imageUrl)!)
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
            WatchListButton(viewModel: WatchListButtonViewModel(isOnWatchList: viewModel.movie.isOnWatchList, movieId: viewModel.movie.id))
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
            .cacheOriginalImage()
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
    "isOnWatchlist": false,
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
