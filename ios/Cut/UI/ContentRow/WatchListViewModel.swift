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
    let content: Content
    let index: Int?
    private var currentRequest: Apollo.Cancellable?

    init(content: Content, index: Int? = nil) {
        self.content = content
        self.isOnWatchList = content.isOnWatchList
        self.index = index
    }

    func toggleWatchList() {
        let originalIsOnWatchList = isOnWatchList
        isOnWatchList = !isOnWatchList
        currentRequest?.cancel()
        if originalIsOnWatchList {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.RemoveFromWatchListMutation(contentId: content.id)) { [weak self] result in
                    guard let self = self else { return }
                    guard case .success(let data) = result, let newId = data.data?.removeFromWatchList.id else {
                        self.isOnWatchList = originalIsOnWatchList
                        return
                    }
                    updateCache(add: false, contentId: newId)
                }
        } else {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.AddToWatchListMutation(contentId: content.id)) { [weak self] result in
                    guard let self = self else { return }
                    guard case .success(let data) = result, let newId = data.data?.addToWatchList.id else {
                        self.isOnWatchList = originalIsOnWatchList
                        return
                    }
                    updateCache(add: true, contentId: newId)
                }
        }
    }

    private func updateCache(add: Bool, contentId: String) {
        // capture locally
        let content = content
        let index = index
        AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableContentFragment.self, withKey: "Content:\(contentId)", { set in
                    set.isOnWatchList = add
                })
            } catch {
                print(error)
            }
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableExtendedMovieFragment.self, withKey: "ExtendedMovie:\(contentId)") { set in
                    set.isOnWatchList = add
                }
            } catch {
                print(error)
            }
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableExtendedMovieFragment.self, withKey: "ExtendedTVShow:\(contentId)") { set in
                    set.isOnWatchList = add
                }
            } catch {
                print(error)
            }
            do {
                try txn.update(CutGraphQL.WatchListMutationLocalCacheMutation()) { set in
                    if add {
                        set.watchList.append(CutGraphQL.WatchListMutationLocalCacheMutation.Data.WatchList(
                            title: content.title,
                            id: contentId,
                            allIds: content.allIds,
                            poster_url: content.poster_url,
                            url: content.url,
                            type: content.type,
                            genres: content.genres,
                            isOnWatchList: true
                        ))
                    } else {
                        let findIndex = {
                            let existing = try txn.read(query: CutGraphQL.WatchListQuery())
                            return existing.watchList.firstIndex{ item in
                                item.id == contentId || item.allIds.contains(contentId)
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
