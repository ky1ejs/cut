//
//  Color.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI
import UIKit

protocol Themeable {
    var background: UIColor { get }
    var grayBackground: UIColor { get }
    var lightgray: UIColor { get }
    
    var text: UIColor { get }
    var subtitle: UIColor { get }
    var redactionForeground: UIColor { get }
    var redactionBackground: UIColor { get }
    var skeletonGradient: Gradient { get }
    var primaryButton: UIColor { get }
    var overlayBackground: UIColor { get }
    var imagePlaceholder: UIColor { get }
}

extension UIColor {
    var color: Color { Color(uiColor: self) }
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
    var lightgray: UIColor { .cut_gray08 }
    var primaryButton: UIColor { .cut_black }

    var text: UIColor { .black }
    var redactionForeground: UIColor { .gray30 }
    var redactionBackground: UIColor { .gray90 }
    var skeletonGradient: Gradient { Gradient(colors: [UIColor.gray20, UIColor.gray45, UIColor.gray20].map { $0.color }) }
    var overlayBackground: UIColor { .gray95 }
    var imagePlaceholder: UIColor { .gray80 }
}

struct DarkTheme: Themeable {
    var background: UIColor { .black }
    var grayBackground: UIColor { .cut_gray02 }
    var lightgray: UIColor { .cut_gray02 }
    var subtitle: UIColor { .cut_gray08 }
    var primaryButton: UIColor { .white }

    var text: UIColor { .white }
    var redactionForeground: UIColor { .white }
    var redactionBackground: UIColor { .gray20 }
    var skeletonGradient: Gradient {
        let tranlucent = UIColor.white.withAlphaComponent(0.4)
        let gradient = [tranlucent, .gray90.withAlphaComponent(0.8), tranlucent]
        return Gradient(colors: gradient.map { $0.color })
    }
    var overlayBackground: UIColor { .gray10 }
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
