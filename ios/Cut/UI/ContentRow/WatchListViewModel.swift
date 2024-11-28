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
    private(set) var content: Content
    let index: Int?
    private var currentRequest: Apollo.Cancellable?
    private var watch: Apollo.Cancellable?

    init(content: Content, index: Int? = nil) {
        self.content = content
        self.isOnWatchList = content.isOnWatchList
        self.index = index
        watch = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetContentQuery(id: content.id)) { [weak self] result in
            switch result.parseGraphQL() {
            case .success(let data):
                if let content = data.content.result.asContentInterface?.fragments.contentFragment {
                    self?.content = content
                    self?.isOnWatchList = content.isOnWatchList
                }
            case .failure(let error):
                print(error)
            }
        }
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
                    WatchListCacheUpdate.updateCache(add: false, maybeIndex: index, newContentId: newId, content: content)
                }
        } else {
            currentRequest = AuthorizedApolloClient.shared.client
                .perform(mutation: CutGraphQL.AddToWatchListMutation(contentId: content.id)) { [weak self] result in
                    guard let self = self else { return }
                    guard case .success(let data) = result, let newId = data.data?.addToWatchList.id else {
                        self.isOnWatchList = originalIsOnWatchList
                        return
                    }
                    WatchListCacheUpdate.updateCache(add: true, maybeIndex: index, newContentId: newId, content: content)
                }
        }
    }
}
