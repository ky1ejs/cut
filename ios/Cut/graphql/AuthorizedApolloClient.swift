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
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()

}

class AuthorizationInterceptor: ApolloInterceptor {
    var id: String = UUID().uuidString
    lazy var version = getAppVersion()

    func interceptAsync<Operation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) where Operation : GraphQLOperation {
        if let sessionId = SessionManager.shared.sessionId {
            request.addHeader(name: "Authorization", value: sessionId)
        }
        if let version = version {
            request.addHeader(name: "client_version", value: version)
        }
        request.addHeader(name: "platform", value: "ios")
        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion)
    }

    func getAppVersion() -> String? {
        if let infoDictionary = Bundle.main.infoDictionary,
           let version = infoDictionary["CFBundleShortVersionString"] as? String {
            return version
        }
        return nil
    }
}

class ErrorInterceptor: ApolloErrorInterceptor {
    func handleErrorAsync<Operation>(error: Error, chain: Apollo.RequestChain, request: Apollo.HTTPRequest<Operation>, response: Apollo.HTTPResponse<Operation>?, completion: @escaping (Result<Apollo.GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : ApolloAPI.GraphQLOperation {
        if let inteceptorError = error as? ResponseCodeInterceptor.ResponseCodeError, let graphqlError = inteceptorError.graphQLError {
            if let errors = graphqlError["errors"] as? [JSONObject],
               let extensions = errors.first?["extensions"] as? JSONObject,
               let code = extensions["code"] as? String,
               code == "UNAUTHORIZED" {
                try? SessionManager.shared.logOut()
            }
        }
        completion(.failure(error))
    }
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    var id: String = UUID().uuidString

    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0)
        return interceptors
    }

    override func additionalErrorInterceptor<Operation>(for operation: Operation) -> ApolloErrorInterceptor? where Operation : GraphQLOperation {
        return ErrorInterceptor()
    }

}

