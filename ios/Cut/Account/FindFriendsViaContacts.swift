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
    @State private var showShareSheet = false
    let completion: () -> Void

    enum ViewState {
        case loading
        case result([CutGraphQL.ProfileFragment])
        case error(Error)
    }

    init(completion: @escaping () -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized, .restricted:
            state = .loading
        default:
            state = .result([])
            completion()
        }
        self.completion = completion
    }

    var body: some View {
        VStack {
            switch state {
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
                if data.isEmpty {
                    VStack {
                        Text("You're a trend setter")
                            .font(.cut_title1)
                            .bold()
                        Text("We didn't find any of your contacts on Cut.")
                            .padding(.bottom, 38)
                        ShareLink(item: URL(string: "https://cut.watch")!) {
                            Text("Share cut with friends")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        TertiaryButton("Done") {
                            completion()
                        }
                    }.padding(.horizontal, 12)
                } else {
                    List {
                        ForEach(data, id: \.id) { profile in
                            ProfileRow(profile: profile)
                        }
                    }
                    .listStyle(.plain)
                    .toolbar {
                        Button("Done") {
                            completion()
                        }
                    }
                }
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
    }
}

#Preview {
    FindFriendsViaContacts() {

    }
}
