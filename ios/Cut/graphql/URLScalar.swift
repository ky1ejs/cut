//
//  URLScalar.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import Foundation

extension CutGraphQL {
    typealias URL = Foundation.URL
}

extension Foundation.URL: CustomScalarType {
  public init (_jsonValue value: JSONValue) throws {
    guard let urlString = value as? String,
          let url = URL(string: urlString) else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Foundation.Date.self)
    }

    self = url
  }

  public var _jsonValue: JSONValue {
      absoluteString
  }
}

