//
//  Color.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI
import UIKit

private struct ThemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Themeable = Theme.current
}

extension EnvironmentValues {
  var theme: Themeable {
    get { self[ThemeEnvironmentKey.self] }
    set { self[ThemeEnvironmentKey.self] = newValue }
  }
}

protocol Themeable {
    var background: UIColor { get }
    var grayBackground: UIColor { get }
    var lightgray: UIColor { get }
    var extraLightGray: UIColor { get }
    var darkGray: UIColor { get }

    var text: UIColor { get }
    var textFieldBackground: UIColor { get }
    var textFieldPlaceholderColor: UIColor { get }

    var subtitle: UIColor { get }
    var redactionForeground: UIColor { get }
    var redactionBackground: UIColor { get }
    var skeletonGradient: Gradient { get }

    var primaryButtonBackground: UIColor { get }
    var primaryButtonBackgroundDepressed: UIColor { get }
    var primaryButtonText: UIColor { get }
    var primaryDisabledBackground: UIColor { get }
    var primaryDisabledText: UIColor { get }
    var secondaryButtonBackground: UIColor { get }
    var secondaryButtonBackgroundDepressed: UIColor { get }
    var secondaryButtonText: UIColor { get }
    var secondaryDisabledBackground: UIColor { get }
    var secondaryDisabledText: UIColor { get }

    var overlayBackground: UIColor { get }
    var imagePlaceholder: UIColor { get }
}

extension UIColor {
    var color: Color { Color(uiColor: self) }
}

struct ThemeReader {
    @Environment(\.colorScheme) var colorScheme
}

struct Theme {
    static var current: Themeable {
        switch UITraitCollection.current.userInterfaceStyle {
        case .dark:
            return DarkTheme()
        case .light, .unspecified:

            return LightTheme()
        @unknown default:
            return LightTheme()
        }
    }

    static func `for`(_ scheme: ColorScheme) -> Themeable {
        switch scheme {
        case .dark:
            return DarkTheme()
        case .light:
            return LightTheme()
        @unknown default:
            return LightTheme()
        }
    }
}

struct LightTheme: Themeable {
    var background: UIColor { .white }
    var grayBackground: UIColor { .cut_gray08 }
    var subtitle: UIColor { .cut_gray03 }
    var extraLightGray: UIColor { .gray90 }
    var lightgray: UIColor { .gray20 }
    var darkGray: UIColor { .gray20 }

    // Button
    var primaryButtonBackground: UIColor { .cut_black }
    var primaryButtonBackgroundDepressed: UIColor { .gray25 }
    var primaryButtonText: UIColor { .white }
    var primaryDisabledBackground: UIColor { .gray70 }
    var primaryDisabledText: UIColor { .gray25 }
    var secondaryButtonBackground: UIColor { .gray20 }
    var secondaryButtonBackgroundDepressed: UIColor { .gray40 }
    var secondaryButtonText: UIColor { .white }
    var secondaryDisabledBackground: UIColor { .gray05 }
    var secondaryDisabledText: UIColor { .gray50 }

    var text: UIColor { .black }
    var textFieldBackground: UIColor { .gray90 }
    var textFieldPlaceholderColor: UIColor { .gray40 }
    var redactionForeground: UIColor { .gray30 }
    var redactionBackground: UIColor { .gray90 }
    var skeletonGradient: Gradient { Gradient(colors: [UIColor.gray20, UIColor.gray45, UIColor.gray20].map { $0.color }) }
    var overlayBackground: UIColor { .gray95 }
    var imagePlaceholder: UIColor { .gray80 }
}

struct DarkTheme: Themeable {
    var background: UIColor { .black }
    var grayBackground: UIColor { .cut_gray02 }
    var lightgray: UIColor { .gray20 }
    var extraLightGray: UIColor { .gray10 }
    var darkGray: UIColor { .gray80 }
    var subtitle: UIColor { .cut_gray08 }
    
    // Buttons
    var primaryButtonBackground: UIColor { .white }
    var primaryButtonBackgroundDepressed: UIColor { .gray85 }
    var primaryButtonText: UIColor { .cut_black }
    var primaryDisabledBackground: UIColor { .gray30 }
    var primaryDisabledText: UIColor { .gray70 }
    var secondaryButtonBackground: UIColor { .gray20 }
    var secondaryButtonBackgroundDepressed: UIColor { .gray40 }
    var secondaryButtonText: UIColor { .white }
    var secondaryDisabledBackground: UIColor { .gray15 }
    var secondaryDisabledText: UIColor { .gray50 }

    var text: UIColor { .white }
    var textFieldBackground: UIColor { .gray15 }
    var textFieldPlaceholderColor: UIColor { .gray70 }
    var redactionForeground: UIColor { .white }
    var redactionBackground: UIColor { .gray20 }
    var skeletonGradient: Gradient {
        let tranlucent = UIColor.white.withAlphaComponent(0.4)
        let gradient = [tranlucent, .gray90.withAlphaComponent(0.8), tranlucent]
        return Gradient(colors: gradient.map { $0.color })
    }
    var overlayBackground: UIColor { .gray10.withAlphaComponent(0.6) }
    var imagePlaceholder: UIColor { .gray20 }
}

extension UIColor {
    static var cut_orange: UIColor { UIColor(hue:0.09, saturation:0.7, brightness:1, alpha:1) }
    static var cut_black: UIColor { UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1) }
    static var cut_gray02: UIColor { UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) }
    static var cut_gray03: UIColor { UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1) }
    static var cut_gray06: UIColor { UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) }
    static var cut_gray08: UIColor { UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) }
    static var cut_gray09: UIColor { UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) }

    static var gray05 = UIColor(white: 0.05, alpha: 1)
    static var gray10 = UIColor(white: 0.10, alpha: 1)
    static var gray15 = UIColor(white: 0.15, alpha: 1)
    static var gray20 = UIColor(white: 0.20, alpha: 1)
    static var gray25 = UIColor(white: 0.25, alpha: 1)
    static var gray30 = UIColor(white: 0.30, alpha: 1)
    static var gray35 = UIColor(white: 0.35, alpha: 1)
    static var gray40 = UIColor(white: 0.40, alpha: 1)
    static var gray45 = UIColor(white: 0.45, alpha: 1)
    static var gray50 = UIColor(white: 0.50, alpha: 1)
    static var gray55 = UIColor(white: 0.55, alpha: 1)
    static var gray60 = UIColor(white: 0.60, alpha: 1)
    static var gray65 = UIColor(white: 0.65, alpha: 1)
    static var gray70 = UIColor(white: 0.70, alpha: 1)
    static var gray75 = UIColor(white: 0.75, alpha: 1)
    static var gray80 = UIColor(white: 0.80, alpha: 1)
    static var gray85 = UIColor(white: 0.85, alpha: 1)
    static var gray90 = UIColor(white: 0.90, alpha: 1)
    static var gray95 = UIColor(white: 0.95, alpha: 1)
}
