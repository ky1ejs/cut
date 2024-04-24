//
//  UnknownError.swift
//  Cut
//
//  Created by Kyle Satti on 4/23/24.
//

import Foundation

struct UnknownError: LocalizedError {
    var errorDescription: String? { "Unknown error -- data missing" }
}
