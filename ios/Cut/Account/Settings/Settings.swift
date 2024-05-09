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
    @Binding var isPresented: Bool

    var body: some View {
        List {
            NavigationLink("Changelog", destination: {
                Changelog()
            })
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
            NavigationLink("Find friends", destination: {
                FindFriendsViaContacts()
            })
        }
        .navigationTitle("Settings")
        .toolbar {
            Button("Done") {
                isPresented = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        Settings(isPresented: Binding.constant(true))
    }
}
