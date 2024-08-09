//
//  CutButton.swift
//  Cut
//
//  Created by Kyle Satti on 3/2/24.
//

import SwiftUI

struct PrimaryButton: View {
    let text: String
    let isLoading: Bool
    let action: () -> ()

    enum ButtonState {
        case loading, notLoading
    }

    init(_ text: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.text = text
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            if isLoading {
                ProgressView().colorInvert()
            } else {
                Text(text)
            }
        })
        .disabled(isLoading)
        .buttonStyle(PrimaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme

    func makeBody(configuration: Configuration) -> some View {
        FilledButtonStyle(
            backgroundColor: theme.primaryButtonBackground.color,
            depressedColor: theme.primaryButtonBackgroundDepressed.color,
            textColor: theme.primaryButtonText.color,
            disabledBackgroundColor: theme.primaryDisabledBackground.color,
            disabledTextColor: theme.primaryDisabledText.color
        ).makeBody(configuration: configuration)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme

    func makeBody(configuration: Configuration) -> some View {
        FilledButtonStyle(
            backgroundColor: theme.secondaryButtonBackground.color,
            depressedColor: theme.secondaryButtonBackgroundDepressed.color,
            textColor: theme.secondaryButtonText.color,
            disabledBackgroundColor: theme.secondaryDisabledBackground.color,
            disabledTextColor: theme.secondaryDisabledText.color
        )
        .makeBody(configuration: configuration)
    }
}

struct FilledButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let depressedColor: Color
    let textColor: Color
    let disabledBackgroundColor: Color
    let disabledTextColor: Color

    struct Container: View {
        let backgroundColor: Color
        let depressedColor: Color
        let textColor: Color
        let disabledBackgroundColor: Color
        let disabledTextColor: Color

        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(getBackgroundColor(configuration))
                    configuration
                        .label
                        .bold()
                        .foregroundStyle(getTextColor())
            }.frame(height: 44)
        }

        func getBackgroundColor(_ config: ButtonStyle.Configuration) -> Color {
            if !isEnabled {
                return disabledBackgroundColor
            }
            if config.isPressed {
                return depressedColor
            }
            return backgroundColor
        }

        func getTextColor() -> Color {
            return isEnabled ? textColor : disabledTextColor
        }
    }

    func makeBody(configuration: Configuration) -> some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundStyle(getBackgroundColor(configuration))
//                configuration
//                    .label
//                    .bold()
//                    .foregroundStyle(getTextColor())
//        }.frame(height: 44)
        Container(
            backgroundColor: backgroundColor,
            depressedColor: depressedColor,
            textColor: textColor,
            disabledBackgroundColor: disabledBackgroundColor,
            disabledTextColor: disabledTextColor,
            configuration: configuration
        )
    }
}

struct StatedPrimaryButton: View {
    let text: String
    let action: (StatedPrimaryButton) -> Void
    @State var state = false

    var body: some View {
        PrimaryButton(text, isLoading: state) {
            action(self)
        }
    }
}

#Preview {
    HStack {
        PrimaryButton("Test", isLoading: true) {}
    }.padding(.horizontal, 30)
}

#Preview {
    HStack {
        PrimaryButton("Test", isLoading: false) {}
    }.padding(.horizontal, 30)
}

#Preview {
    HStack {
        PrimaryButton("Test", isLoading: false) {}
            .disabled(true)
    }.padding(.horizontal, 30)
}
