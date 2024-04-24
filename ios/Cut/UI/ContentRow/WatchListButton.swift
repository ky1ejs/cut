//
//  WatchListButton.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI

struct WatchListButton: View {
    @State var watchListViewModel: WatchListViewModel

    init(movie: Movie, index: Int? = nil) {
        watchListViewModel = WatchListViewModel(movie: movie, index: index)
    }

    var body: some View {
        _WatchListButton(isOnWatchList: watchListViewModel.isOnWatchList) {
            watchListViewModel.toggleWatchList()
        }
    }
}

private struct _WatchListButton: View {
    let isOnWatchList: Bool
    let buttonTapped: () -> Void

    var body: some View {
        Button(action: {
            buttonTapped()
        }, label: {
            let image: UIImage = isOnWatchList ? .init(named: "check")! : .init(named: "plus")!
            Image(uiImage: image)
                .tint(isOnWatchList ? .black : .white)
        })
        .buttonStyle(PlainButtonStyle())
        .frame(width: 36, height: 36)
        .background(Circle().foregroundStyle(isOnWatchList ? Color.black : Color.sub))
    }
}

struct TodoRow_Previews: PreviewProvider {
    struct Container: View {
        @State var on: Bool = false

        var body: some View {
            _WatchListButton(isOnWatchList: on) {
                on.toggle()
            }
        }
    }

    static var previews: some View {
        Container()
    }
}

#Preview {
    TodoRow_Previews.Container()
}
