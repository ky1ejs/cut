//
//  Formatters.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import Foundation

struct Formatters  {
    static let twoFractionDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    static let df = DateFormatter()
    static var yearDF: DateFormatter {
        df.dateFormat = "yyyy"
        return df
    }
    static var fullDF: DateFormatter {
        df.dateStyle = .medium
        return df
    }
}
