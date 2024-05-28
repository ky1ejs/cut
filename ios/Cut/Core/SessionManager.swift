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
    private var inFlightRequest: Apollo.Cancellable?

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

    func signUp(completion: @escaping (Result<String, SignInError>) -> ()) {
        guard sessionId == nil && inFlightRequest == nil else { return }
        let deviceName = UIDevice.current.name
        inFlightRequest = client.perform(mutation: CutGraphQL.AnnonymousSignUpMutation(deviceName: deviceName)) { [weak self] result in
            self?.inFlightRequest = nil
            guard case .success(let response) = result, let sessionId = response.data?.annonymousSignUp.session_id else {
                completion(.failure(.unknown))
                return
            }
            do {
                try self?.storeSessionId(sessionId)
                self?.sessionId = sessionId
                completion(.success(sessionId))
            } catch {
                completion(.failure(.error(error)))
            }
        }
    }

    func completeAccount(_ input: CutGraphQL.CompleteAccountInput, completion: @escaping (Result<String, SignInError>) -> ()) -> Apollo.Cancellable {
        guard sessionId != nil && inFlightRequest == nil else {
            completion(.failure(.unknown))
            return inFlightRequest!
        }

        let cancellable = client.perform(mutation: CutGraphQL.CompleteAccountMutation(params: input), resultHandler: { [weak self] result in
            self?.inFlightRequest = nil
            switch result.parseGraphQL() {
            case .success(let data):
                do {
                    let account = data.completeAccount.completeAccount.fragments.completeAccountFragment
                    let sessionId = data.completeAccount.updatedDevice.session_id
                    try self?.userLoggedIn(account: account, sessionId: sessionId)
                    completion(.success(sessionId))
                } catch {
                    completion(.failure(.error(error)))
                }
            case .failure(let error):
                completion(.failure(.error(error)))
            }
        })
        inFlightRequest = cancellable
        return cancellable
    }

    func userLoggedIn(account: CutGraphQL.CompleteAccountFragment, sessionId: String) throws {
        try self.storeSessionId(sessionId)
        self.sessionId = sessionId

        AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
            try txn.update(CutGraphQL.GetAccountMutationLocalCacheMutation()) { set in
                set.account.asIncompleteAccount = nil
                set.account.asCompleteAccount =  CutGraphQL.GetAccountMutationLocalCacheMutation.Data.Account.AsCompleteAccount(
                    favoriteMovies: [],
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
    }

    func logOut() throws {
        try logOut(remotely: true)
    }

    func accountDeleted() throws {
        try logOut(remotely: false)
    }
}
