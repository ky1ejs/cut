//
//  Settings.swift
//  Cut
//
//  Created by Kyle Satti on 2/27/24.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        List {
            NavigationLink("Changelog", destination: {
                Changelog()
                    .navigationTitle("Changelog")
                    .navigationBarTitleDisplayMode(.inline)
            })
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    Settings()
}
