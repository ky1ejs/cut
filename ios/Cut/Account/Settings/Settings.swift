//
//  Settings.swift
//  Cut
//
//  Created by Kyle Satti on 2/27/24.
//

import SwiftUI
import Apollo

struct Settings: View {
    @State private var inFlightRequest: Cancellable?

    var body: some View {
        List {
            NavigationLink("Changelog", destination: {
                Changelog()
                    .navigationTitle("Changelog")
                    .navigationBarTitleDisplayMode(.inline)
            })
            .navigationTitle("Settings")
            HStack {
                Button(inFlightRequest != nil ? "Sending test push..." : "Send test push") {
                    inFlightRequest?.cancel()
                    inFlightRequest = AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.SendTestPushQuery(), cachePolicy: .fetchIgnoringCacheCompletely, resultHandler: { result in
                        inFlightRequest = nil
                    })
                }
                .disabled(inFlightRequest != nil)
                Spacer()
                if inFlightRequest != nil {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    Settings()
}
