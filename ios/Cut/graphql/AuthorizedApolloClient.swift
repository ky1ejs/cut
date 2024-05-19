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
        let provider = NetworkInterceptorProvider(store: store, client: client)
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
    private let id = UUID().uuidString
    let store: ApolloStore
    let client: URLSessionClient

    init(store: ApolloStore, client: URLSessionClient) {
        self.store = store
        self.client = client
        super.init(store: store)
    }

    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
        return [
              AuthorizationInterceptor(),
              MaxRetryInterceptor(),
              CacheReadInterceptor(store: store),
              NetworkFetchInterceptor(client: client),
              ResponseLoggingInterceptor(),
              ResponseCodeInterceptor(),
              MultipartResponseParsingInterceptor(),
              JSONResponseParsingInterceptor(),
              AutomaticPersistedQueryInterceptor(),
              CacheWriteInterceptor(store: self.store)
            ]
    }

    override func additionalErrorInterceptor<Operation>(for operation: Operation) -> ApolloErrorInterceptor? where Operation : GraphQLOperation {
        return ErrorInterceptor()
    }
}

class ResponseLoggingInterceptor: ApolloInterceptor {

  enum ResponseLoggingError: Error {
    case notYetReceived
  }

  public var id: String = UUID().uuidString

  func interceptAsync<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) {
    defer {
      // Even if we can't log, we still want to keep going.
      chain.proceedAsync(
        request: request,
        response: response,
        interceptor: self,
        completion: completion
      )
    }

    guard let receivedResponse = response else {
      chain.handleErrorAsync(
        ResponseLoggingError.notYetReceived,
        request: request,
        response: response,
        completion: completion
      )
      return
    }

    print("HTTP Response: \(receivedResponse.httpResponse)")

    if let stringData = String(bytes: receivedResponse.rawData, encoding: .utf8) {
        print("Data: \(stringData)")
    } else {
        print("Could not convert data to string!")
    }
  }
}

