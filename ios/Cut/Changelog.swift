//
//  Changelog.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI
import MarkdownUI

struct Changelog: View {
    private let changelog: String

    init() {
        let url = Bundle.main.url(forResource: "CHANGELOG", withExtension: "md")!
        let data = try! Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8)!
        self.changelog = string
    }

    var body: some View {
        ScrollView {
                HStack {
                    Markdown(changelog)
                    Spacer()
                }.padding()

        }.scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    Changelog()
}
