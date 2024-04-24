//
//  GraphQLResultParser.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import Apollo
import ApolloAPI

func parseResult<T: RootSelectionSet>(_ result: Result<GraphQLResult<T>, Error>) -> Result<T, Error> {
    switch result {
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

