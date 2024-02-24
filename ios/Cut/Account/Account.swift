//
//  Account.swift
//  Cut
//
//  Created by Kyle Satti on 2/9/24.
//

import SwiftUI

struct Account: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Changelog", destination: {
                    Changelog()
                        .navigationTitle("Changelog")
                        .navigationBarTitleDisplayMode(.inline)
                })
                .navigationTitle("Account")
            }
        }
    }
}

#Preview {
    Account()
}
