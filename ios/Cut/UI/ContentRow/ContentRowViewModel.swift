//
//  ContentRowViewModel.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI
import Apollo

class ContentRowViewModel: ObservableObject {
    let movie: CutGraphQL.MovieFragment
    let index: Int?
    @State private(set) var isOnWatchList: Bool
    private var currentRequest: Apollo.Cancellable?

    init(movie: CutGraphQL.MovieFragment, index: Int? = nil) {
        self.movie = movie
        self.index = index
        self.isOnWatchList = movie.isOnWatchList
    }

    var imageUrl: String { return movie.poster_url }
    var title: String { return movie.title }

    var subtitle: String {
        return movie.mainGenre?.name ?? ""
    }

    func toggleWatchList() {
        let original = isOnWatchList
        isOnWatchList = !isOnWatchList
        currentRequest?.cancel()
        if original {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.RemoveFromWatchListMutation(movieId: movie.id)) { [weak self] result in
                    guard let self = self else { return }
                    guard case .success(let data) = result, let newId = data.data?.removeFromWatchList.id else {
                        self.isOnWatchList = original
                        return
                    }
                    let movie = self.movie
                    let index = self.index
                    AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
                        do {
                            let findIndex = {
                                let existing = try txn.read(query: CutGraphQL.WatchListQuery())
                                return existing.watchList.firstIndex{ item in
                                    item.id == movie.id
                                }!
                            }
                            let finalIndex = try index ?? findIndex()
                            try! txn.update(CutGraphQL.WatchListMutationLocalCacheMutation()) { set in
                                set.watchList.remove(at: finalIndex)
                            }
                        } catch {
                            print(error)
                        }
                        try! txn.updateObject(ofType: CutGraphQL.MutableMovieFragment.self, withKey: "Movie:\(newId)", { set in
                            set.isOnWatchList = false
                        })
                        }
                }
        } else {
            currentRequest = AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.AddToWatchListMutation(movieId: movie.id)) { [weak self] result in
                guard let self = self else { return }
                guard case .success(let data) = result, let newId = data.data?.addToWatchList.id else {
                    self.isOnWatchList = original
                    return
                }
                let movie = self.movie
                AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
                    let mutation = CutGraphQL.WatchListMutationLocalCacheMutation()
                    do {
                        try txn.updateObject(ofType: CutGraphQL.MutableMovieFragment.self, withKey: "Movie:\(newId)", { set in
                            set.isOnWatchList = true
                        })
                    } catch {}
                    do {
                        try txn.update(mutation) { set in
                            set.watchList.append(CutGraphQL.WatchListMutationLocalCacheMutation.Data.WatchList(
                                title: movie.title,
                                id: newId,
                                poster_url: movie.poster_url,
                                genres: movie.genres,
                                isOnWatchList: true
                            ))
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
