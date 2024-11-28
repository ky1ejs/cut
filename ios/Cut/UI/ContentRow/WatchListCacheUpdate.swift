//
//  WatchListCacheUpdate.swift
//  Cut
//
//  Created by Kyle Satti on 8/9/24.
//

import Foundation

struct WatchListCacheUpdate {
    static func updateCache(add: Bool, maybeIndex: Optional<Int>, newContentId: String, content: Content) {
        AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableContentFragment.self, withKey: "Content:\(newContentId)", { set in
                    set.isOnWatchList = add
                })
            } catch {
                print(error)
            }
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableExtendedMovieFragment.self, withKey: "ExtendedMovie:\(newContentId)") { set in
                    set.isOnWatchList = add
                }
            } catch {
                print(error)
            }
            do {
                try txn.updateObject(ofType: CutGraphQL.MutableExtendedMovieFragment.self, withKey: "ExtendedTVShow:\(newContentId)") { set in
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
                            id: newContentId,
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
                                item.id == newContentId || item.allIds.contains(newContentId)
                            }!
                        }
                        let finalIndex = try maybeIndex ?? findIndex()
                        set.watchList.remove(at: finalIndex)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
