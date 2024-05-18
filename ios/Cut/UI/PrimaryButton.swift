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
            if state == .loading {
                ProgressView().colorInvert()
            } else {
                Text(text)
            }
        })
        .disabled(state == .loading)
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme

    func makeBody(configuration: Configuration) -> some View {
        FilledButtonStyle(
            backgroundColor: theme.primaryButtonBackground.color,
            textColor: theme.primaryButtonText.color
        ).makeBody(configuration: configuration)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme

    func makeBody(configuration: Configuration) -> some View {
        FilledButtonStyle(
            backgroundColor: theme.secondaryButtonBackground.color,
            textColor: theme.secondaryButtonText.color
        )
        .makeBody(configuration: configuration)
    }
}

struct FilledButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let textColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(backgroundColor)
                configuration
                    .label
                    .bold()
                    .foregroundStyle(textColor)
        }.frame(height: 44)
    }
}

struct StatedPrimaryButton: View {
    let text: String
    let action: (StatedPrimaryButton) -> Void
    @State var state = PrimaryButton.ButtonState.notLoading

    var body: some View {
        PrimaryButton(text: text, state: state) {
            action(self)
        }
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
