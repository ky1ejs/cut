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

    static let shared = try! SessionManager()

    private static let TEAM_ID = "X2TBSUCASC"
    private static let SESSION_ID_KEY = "session"
    private let keychain = Keychain(
        service: "watch.cut",
        accessGroup: "\(TEAM_ID).keychain.watch.cut"
    ).accessibility(.afterFirstUnlock)
    private let client = AuthorizedApolloClient.shared.client
    private var inFlightRequest: Apollo.Cancellable?

    init() throws {
        sessionId = try readSessionId()
    }

    enum SignInError: Error {
        case error(Error)
        case unknown
    }

    func signUp(completion: @escaping (Result<String, SignInError>) -> ()) {
        guard sessionId == nil && inFlightRequest == nil else { return }
        let deviceName = UIDevice.current.name
        inFlightRequest = client.perform(mutation: CutGraphQL.SignUpMutation(deviceName: deviceName)) { [weak self] result in
            self?.inFlightRequest = nil
            guard case .success(let response) = result, let sessionId = response.data?.signUp.session_id else {
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
            guard case .success(let response) = result else {
                completion(.failure(.unknown))
                return
            }
            do {
                if let error = response.errors?.first {
                    completion(.failure(.error(error)))
                } else if let data = response.data {
                    let sessionId = data.completeAccount.updatedDevice.session_id
                    try self?.storeSessionId(sessionId)
                    self?.sessionId = sessionId

                    AuthorizedApolloClient.shared.client.store.withinReadWriteTransaction { txn in
                        try txn.update(CutGraphQL.GetAccountMutationLocalCacheMutation()) { set in
                            set.account.asIncompleteAccount = nil
                            set.account.asCompleteAccount =  CutGraphQL.GetAccountMutationLocalCacheMutation.Data.Account.AsCompleteAccount(
                                followerCount: data.completeAccount.completeAccount.followerCount,
                                followingCount: data.completeAccount.completeAccount.followingCount,
                                favoriteMovies: [],
                                watchList: data.completeAccount.completeAccount.watchList.map({ m in
                                    CutGraphQL.GetAccountMutationLocalCacheMutation.Data.Account.AsCompleteAccount.WatchList(
                                        title: m.title,
                                        id: m.id,
                                        allIds: m.allIds,
                                        poster_url: m.poster_url,
                                        url: m.url,
                                        mainGenre: m.mainGenre,
                                        genres: m.genres,
                                        isOnWatchList: m.isOnWatchList
                                    )
                                }),
                                id: data.completeAccount.completeAccount.id,
                                name: data.completeAccount.completeAccount.name,
                                username: data.completeAccount.completeAccount.username,
                                link: data.completeAccount.completeAccount.link
                            )
                        }
                    }

                    completion(.success(sessionId))
                } else {
                    completion(.failure(.unknown))
                }
            } catch {
                completion(.failure(.error(error)))
            }
        })
        inFlightRequest = cancellable
        return cancellable
    }

    private func readSessionId() throws -> String? {
        return try keychain.getString(type(of: self).SESSION_ID_KEY)
    }

    private func storeSessionId(_ id: String) throws {
        try keychain.set(id, key: type(of: self).SESSION_ID_KEY)
    }

    func logOut() throws {
        sessionId = nil
        try keychain.removeAll()
    }
}
