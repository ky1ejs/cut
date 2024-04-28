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
    var darkgray: UIColor { get }
    var lightgray: UIColor { get }
    var primaryButton: UIColor { get }
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
}

struct LightTheme: Themeable {
    var background: UIColor { .white }
    var grayBackground: UIColor { .cut_gray08 }
    var darkgray: UIColor { .cut_gray03 }
    var lightgray: UIColor { .cut_gray08 }
    var primaryButton: UIColor { .cut_black }
}

struct DarkTheme: Themeable {
    var background: UIColor { .black }
    var grayBackground: UIColor { .cut_gray02 }
    var lightgray: UIColor { .cut_gray02 }
    var darkgray: UIColor { .cut_gray08 }
    var primaryButton: UIColor { .white }
}

extension UIColor {
    static var cut_orange: UIColor { UIColor(hue:0.09, saturation:0.7, brightness:1, alpha:1) }
    static var cut_black: UIColor { UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1) }
    static var cut_gray02: UIColor { UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) }
    static var cut_gray03: UIColor { UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1) }
    static var cut_gray06: UIColor { UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) }
    static var cut_gray08: UIColor { UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) }
    static var cut_gray09: UIColor { UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) }
}

extension Color {
    static var cut_sub: Color {
        Color(white: 0, opacity: 0.2)
    }
    static var cut_orange: Color {
        Color(uiColor: .cut_orange)
    }
    static var cut_black: Color {
        Color(uiColor: .cut_black)
    }
}
