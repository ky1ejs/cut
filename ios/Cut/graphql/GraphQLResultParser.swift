//
//  GraphQLResultParser.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import Apollo
import ApolloAPI

extension Result {
    func parseGraphQL<T: RootSelectionSet>() -> Result<T, Error> where Self == Result<GraphQLResult<T>, Error> {
        switch self {
        case .success(let response):
            if let data = response.data {
                return .success(data)
            } else if let error = response.errors?.first {
                return .failure(error)
            } else {
                return .failure(UnknownError())
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

