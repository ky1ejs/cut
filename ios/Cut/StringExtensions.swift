//
//  StringExtensions.swift
//  Cut
//
//  Created by Kyle Satti on 5/10/24.
//

import Foundation

extension String {
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}
