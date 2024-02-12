//
//  ApolloClient.swift
//  Cut
//
//  Created by Kyle Satti on 2/4/24.
//

import Foundation
import Apollo

class AuthorizedApolloClient {
    static let shared = AuthorizedApolloClient()

    private(set) lazy var client: ApolloClient = {
        #if PROD_API
        let url = URL(string: "https://cut-api.fly.dev/graphql")!
        #elseif LOCAL_API
        let url = URL(string: "http://localhost:4000/graphql")!
        #endif
        return ApolloClient(url: url)
    }()

}
