//
//  CutButton.swift
//  Cut
//
//  Created by Kyle Satti on 3/2/24.
//

import SwiftUI

struct PrimaryButton: View {
    let text: String
    let state: ButtonState
    let action: () -> ()
    @Environment(\.colorScheme) private var colorScheme

    enum ButtonState {
        case loading, notLoading
    }

    init(text: String, state: ButtonState = .notLoading, action: @escaping () -> Void) {
        self.text = text
        self.state = state
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                if state == .loading {
                    ProgressView().colorInvert()
                } else {
                    Text(text).bold().foregroundStyle(colorScheme == .dark ? .black : .white)
                }
            }.frame(height: 44)
        }).disabled(state == .loading)
    }
}

#Preview {
    HStack {
        PrimaryButton(text: "Test", state: .loading) {}
    }.padding(.horizontal, 30)
}

#Preview {
    HStack {
        PrimaryButton(text: "Test", state: .notLoading) {}
    }.padding(.horizontal, 30)
}
