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
    private var inFlightLogIn: Apollo.Cancellable?

    init() throws {
        sessionId = try readSessionId()
    }

    struct SignInError: Error {
        let error: Error
    }

    func signUp(completion: @escaping (Result<String, SignInError>) -> ()) {
        guard sessionId == nil && inFlightLogIn == nil else { return }
        let deviceName = UIDevice.current.name
        inFlightLogIn = client.perform(mutation: CutGraphQL.SignUpMutation(deviceName: deviceName)) { [weak self] result in
            self?.inFlightLogIn = nil
            guard case .success(let response) = result, let sessionId = response.data?.signUp.session_id else { return }
            do {
                try self?.storeSessionId(sessionId)
                self?.sessionId = sessionId
                completion(.success(sessionId))
            } catch {
                completion(.failure(SignInError(error: error)))
            }
        }
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
