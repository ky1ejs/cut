//
//  FollowTable.swift
//  Cut
//
//  Created by Kyle Satti on 5/18/24.
//

import SwiftUI

struct FollowTable: View {
    let userId: String
    let direction: FollowDirection
    @State var results: [CutGraphQL.ProfileFragment]? = nil
    @State var error: Error?

    enum FollowDirection {
        case followers, following

        var title: String {
            switch self {
            case .followers:
                return "Followers"
            case .following:
                return "Following"
            }
        }

        var gqlEnum: CutGraphQL.FollowDirection {
            switch self {
            case .followers:
                return .follower
            case .following:
                return .following
            }
        }
    }

    var body: some View {
        VStack {
            if let results = results {
                if results.count > 0 {
                    List {
                        ForEach(results) { p in
                            NavigationLink {
                                ProfileContainer(profile: p)
                            } label: {
                                ProfileRow(profile: p)
                            }
                        }
                    }
                } else {
                    displayMessage("No \(direction.title)")
                }
            } else {
                displayMessage("...loading")
            }
        }
        .navigationTitle(direction.title)
        .task {
            AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetFollowersQuery(profileId: userId, followDirection: .case(direction.gqlEnum))) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    results = data.profileFollow.map { $0.fragments.profileFragment }
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }

    func displayMessage(_ message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
            Spacer()
        }
    }
}
