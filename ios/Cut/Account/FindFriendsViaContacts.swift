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


    enum ViewState {
        case notDetermined, denied, loading
        case result([CutGraphQL.ProfileFragment])
        case error(Error)
    }

    init() {
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
            List {
                ForEach(data, id: \.id) { profile in
                    Text(profile.name)
                    Text(profile.username)
                }
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
