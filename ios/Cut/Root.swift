//
//  ContentView.swift
//  Cut
//
//  Created by Kyle Satti on 2/3/24.
//

import SwiftUI
import Kingfisher

struct Root: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView {
            Browse().tabItem { Label("Feed", systemImage: "film")}
            Search()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            WatchList()
                .tabItem { Label("Watch List", systemImage: "binoculars.fill") }
            Account()
                .tabItem { Label("Account", systemImage: "person.crop.circle.fill") }
        }
        .environment(\.theme, Theme.for(colorScheme))
    }
}

#Preview {
    Root()
}
