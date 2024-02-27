//
//  WatchListViewModel.swift
//  Cut
//
//  Created by Kyle Satti on 2/25/24.
//

import Apollo
import SwiftUI

@Observable
class WatchListViewModel {
    private(set) var isOnWatchList: Bool
    let movie: Movie
    let index: Int?
    private var currentRequest: Apollo.Cancellable?

    init(movie: Movie, index: Int? = nil) {
        self.movie = movie
        self.isOnWatchList = movie.isOnWatchList
        self.index = index
    }

    func toggleWatchList() {
        let originalIsOnWatchList = isOnWatchList
        isOnWatchList = !isOnWatchList
        currentRequest?.cancel()
        if originalIsOnWatchList {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.RemoveFromWatchListMutation(movieId: movie.id)) { [weak self] result in
                    guard let self = self else { return }
                    guard case .success(let data) = result, let newId = data.data?.removeFromWatchList.id else {
                        self.isOnWatchList = originalIsOnWatchList
                        return
                    }
                    updateCache(add: false, movieId: newId)
                }
        } else {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.AddToWatchListMutation(movieId: movie.id)) { [weak self] result in
                    guard let self = self else { return }
                    guard case .success(let data) = result, let newId = data.data?.addToWatchList.id else {
                        self.isOnWatchList = originalIsOnWatchList
                        return
                    }
                    updateCache(add: true, movieId: newId)
                }
        }
    }

    private func updateCache(add: Bool, movieId: String) {
        // capture locally
        let movie = movie
        let index = index
        AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableMovieFragment.self, withKey: "Movie:\(movieId)", { set in
                    set.isOnWatchList = add
                })
            } catch {
                print(error)
            }
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableExtendedMovieFragment.self, withKey: "ExtendedMovie:\(movieId)") { set in
                    set.isOnWatchList = add
                }
            } catch {
                print(error)
            }
            do {
                try txn.update(CutGraphQL.WatchListMutationLocalCacheMutation()) { set in
                    if add {
                        set.watchList.append(CutGraphQL.WatchListMutationLocalCacheMutation.Data.WatchList(
                            title: movie.title,
                            id: movieId,
                            poster_url: movie.poster_url,
                            genres: movie.genres,
                            isOnWatchList: true
                        ))
                    } else {
                        let findIndex = {
                            let existing = try txn.read(query: CutGraphQL.WatchListQuery())
                            return existing.watchList.firstIndex{ item in
                                item.id == movieId
                            }!
                        }
                        let finalIndex = try index ?? findIndex()
                        set.watchList.remove(at: finalIndex)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
