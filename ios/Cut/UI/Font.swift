//
//  Font.swift
//  Cut
//
//  Created by Kyle Satti on 2/22/24.
//

import SwiftUI

extension Font {
    static var cutTitle: Font {
        Font.system(size: 18, weight: .bold, design: .rounded)
    }

    static var cutSubtitle: Font {
        Font.system(size: 13, weight: .semibold, design: .rounded)
    }
}
