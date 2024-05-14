//
//  IntExtensions.swift
//  Cut
//
//  Created by Kyle Satti on 5/12/24.
//

import Foundation

extension Int {
    var runtimeString: String {
        let hours = self / 60
        let remainingMinutes = self % 60

        if hours == 0 {
            return "\(remainingMinutes) min"
        } else if remainingMinutes == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(remainingMinutes) min"
        }
    }
}
