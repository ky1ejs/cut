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
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        FilledButtonStyle(
            backgroundLightColor: .black,
            backgroundDarkColor: .white,
            textLightColor: .black,
            textDarkColor: .white
        )
        .makeBody(configuration: configuration)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        FilledButtonStyle(
            backgroundLightColor: .gray,
            backgroundDarkColor: .gray,
            textLightColor: .white,
            textDarkColor: .white
        )
        .makeBody(configuration: configuration)
    }
}

struct FilledButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    let backgroundLightColor: Color
    let backgroundDarkColor: Color
    let textLightColor: Color
    let textDarkColor: Color

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(colorScheme == .dark ? backgroundDarkColor : backgroundLightColor)
                configuration
                    .label
                    .bold()
                    .foregroundStyle(colorScheme == .dark ? textLightColor : textDarkColor)
        }.frame(height: 44)
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
