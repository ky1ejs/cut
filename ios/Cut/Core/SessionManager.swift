//
//  KeychainManager.swift
//  Cut
//
//  Created by Kyle Satti on 2/10/24.
//

import Foundation
import KeychainAccess
import UIKit
import Apollo

public class SessionManager: ObservableObject {
    @Published private(set) var sessionId: String? = nil
    @Published var isOnboarding: Bool

    static let shared = try! SessionManager()

    private static let SESSION_ID_KEY = "session"
    private let keychain: Keychain
    private let client = AuthorizedApolloClient.shared.client

    init() throws {
        let keychain = Keychain(
            service: "watch.cut",
            accessGroup: "X2TBSUCASC.keychain.watch.cut"
        ).accessibility(.afterFirstUnlock)
        let sessionId = try keychain.getString(SessionManager.SESSION_ID_KEY)

        self.keychain = keychain
        self.sessionId = sessionId
        self.isOnboarding = sessionId == nil
    }

    enum SignInError: Error {
        case error(Error)
        case unknown
    }

    func setAnnonymousSessionToken(_ token: String) throws {
        try storeSessionId(token)
        sessionId = token
        isOnboarding = false
    }

    func userLoggedIn(account: CutGraphQL.CompleteAccountFragment, sessionId: String) throws {
        try self.storeSessionId(sessionId)
        self.sessionId = sessionId

        AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
            try txn.update(CutGraphQL.GetAccountMutationLocalCacheMutation()) { set in
                set.account.asIncompleteAccount = nil
                set.account.asCompleteAccount =  CutGraphQL.GetAccountMutationLocalCacheMutation.Data.Account.AsCompleteAccount(
                    favoriteContent: [],
                    watchList: account.watchList.map({ m in
                        CutGraphQL.GetAccountMutationLocalCacheMutation.Data.Account.AsCompleteAccount.WatchList(
                            title: m.title,
                            id: m.id,
                            allIds: m.allIds,
                            poster_url: m.poster_url,
                            url: m.url,
                            type: m.type,
                            mainGenre: m.mainGenre,
                            genres: m.genres,
                            isOnWatchList: m.isOnWatchList
                        )
                    }),
                    ratings: account.ratings.map({ m in
                        CutGraphQL.GetAccountMutationLocalCacheMutation.Data.Account.AsCompleteAccount.Rating(
                            title: m.title,
                            id: m.id,
                            allIds: m.allIds,
                            poster_url: m.poster_url,
                            url: m.url,
                            type: m.type,
                            mainGenre: m.mainGenre,
                            genres: m.genres,
                            isOnWatchList: m.isOnWatchList
                        )
                    }),
                    id: account.id,
                    name: account.name,
                    username: account.username,
                    share_url: account.share_url,
                    followerCount: account.followerCount,
                    followingCount: account.followingCount,
                    isCurrentUser: account.isCurrentUser
                )
            }
        }
    }

    private func readSessionId() throws -> String? {
        return try keychain.getString(type(of: self).SESSION_ID_KEY)
    }

    private func storeSessionId(_ id: String) throws {
        try keychain.set(id, key: type(of: self).SESSION_ID_KEY)
    }

    private func logOut(remotely: Bool) throws {
        if remotely {
            AuthorizedApolloClient.shared.client.perform(mutation: CutGraphQL.LogOutMutation())
        }
        sessionId = nil
        isOnboarding = true
        try keychain.removeAll()
        AuthorizedApolloClient.shared.client.store.clearCache()
    }

    func logOut() throws {
        try logOut(remotely: true)
    }

    func accountDeleted() throws {
        try logOut(remotely: false)
    }
}
