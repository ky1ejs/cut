//
//  Font.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI

extension Font {
    static var cut_largeTitle: Font {
        fontWithSize(34)
    }

    static var cut_title1: Font {
        fontWithSize(26)
    }

    static var cut_title2: Font {
        fontWithSize(22)
    }

    static var cut_title3: Font {
        fontWithSize(20)
    }

    static var cut_headline: Font {
        fontWithSize(17, .semibold)
    }

    static var cut_body: Font {
        fontWithSize(17, .medium)
    }

    static var cut_callout: Font {
        fontWithSize(16, .medium)
    }

    static var cut_subheadline: Font {
        fontWithSize(15, .medium)
    }

    static var cut_footnote: Font {
        fontWithSize(14, .medium)
    }

    static var cut_caption1: Font {
        fontWithSize(12, .medium)
    }

    static var cut_caption2: Font {
        fontWithSize(11, .medium)
    }

    private static func fontWithSize(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        Font.system(size: size, weight: weight, design: .rounded)
    }
}
