//
//  FindFriendsViaContacts.swift
//  Cut
//
//  Created by Kyle Satti on 3/22/24.
//

import SwiftUI
import Contacts

struct FindFriendsViaContacts: View {
    @State private var state: ViewState
    @Binding private var presented: Bool

    enum ViewState {
        case notDetermined, denied, loading
        case result([CutGraphQL.ProfileFragment])
        case error(Error)
    }

    init(isPresented: Binding<Bool>? = nil) {
        if let presented = isPresented {
            _presented = presented
        } else {
            _presented = Binding.constant(true)
        }
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .restricted: state = .loading
        case .denied: state = .denied
        case .notDetermined: state = .notDetermined
        @unknown default:
            fatalError()
        }
    }

    var body: some View {
        switch state {
        case .denied:
            Text("Update Settings")
        case .loading:
            ProgressView()
                .task {
                    do {
                        let profiles = try await ContactSyncer.sync()
                        state = .result(profiles)
                    } catch {
                        state = .error(error)
                    }
                }
        case .result(let data):
            NavigationStack {
                List {
                    ForEach(data, id: \.id) { profile in
                        NavigationLink(destination: Profile(profile: .otherUser(.loading(profile)))) {
                            ProfileRow(profile: profile)
                        }
                    }
                }
                .listStyle(.plain)
                .toolbar(content: {
                    Button("Done") {
                        self.presented = false
                    }
                })
                .navigationTitle("Find Friends")
                .navigationBarTitleDisplayMode(.inline)
            }
        case .notDetermined:
            SecondaryButton(text: "Sync") {
                CNContactStore().requestAccess(for: .contacts) { granted, error in
                    state = granted ? .loading : .denied
                }
            }
        case .error(let error):
            Text(error.localizedDescription)
        }
    }
}

#Preview {
    FindFriendsViaContacts()
}
