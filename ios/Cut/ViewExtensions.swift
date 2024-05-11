//
//  ViewExtensions.swift
//  Cut
//
//  Created by Kyle Satti on 5/10/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }

//    @ViewBuilder
//    func redacted(if condition: Bool) -> some View {
//        redacted(reason: condition ? .placeholder : [])
//    }
}
