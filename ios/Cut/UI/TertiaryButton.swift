//
//  SecondaryButton.swift
//  Cut
//
//  Created by Kyle Satti on 3/18/24.
//

import SwiftUI

struct TertiaryButton: View {
    @Environment(\.theme) private var theme
    let text: String
    let action: () -> Void

    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundStyle(theme.primaryButtonBackground.color)
        })
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
}

#Preview {
    TertiaryButton("Test") {

    }
}
