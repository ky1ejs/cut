//
//  SecondaryButton.swift
//  Cut
//
//  Created by Kyle Satti on 3/18/24.
//

import SwiftUI

struct SecondaryButton: View {
    let text: String
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action, label: {
            Text(text).foregroundStyle(colorScheme == .light ? .black : .white)
        })
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
}

#Preview {
    SecondaryButton(text: "Test") {

    }
}
