//
//  DateScalar.swift
//  Cut
//
//  Created by Kyle Satti on 5/2/24.
//

import Foundation

extension CutGraphQL {
    typealias Date = Foundation.Date
}

struct DF {
    static var df = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        return df
    }()
}

extension Foundation.Date: CustomScalarType {
  public init (_jsonValue value: JSONValue) throws {
    guard let dateString = value as? String,
          let date = DF.df.date(from: dateString) else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Foundation.Date.self)
    }

    self = date
  }

  public var _jsonValue: JSONValue {
      DF.df.string(from: self)
  }
}

