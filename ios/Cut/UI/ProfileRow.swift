//
//  ProfileRow.swift
//  Cut
//
//  Created by Kyle Satti on 3/23/24.
//

import SwiftUI
import Apollo
import ApolloAPI

struct ProfileRow: View {
    private let debouncer = Debouncer(delay: 0.5)
    @State private var watch: Apollo.Cancellable? = nil
    @State private var profile: CutGraphQL.ProfileFragment
    @State private var isFollowing: Bool
    @State private var inFlightRequest: Apollo.Cancellable?

    init(profile: CutGraphQL.ProfileFragment) {
        self.profile = profile
        self.isFollowing = profile.isFollowing
    }

    var body: some View {
        HStack {
            ProfileImage()
                .frame(width: 80)
                .frame(height: 80)
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(profile.name).font(.cut_headline)
                Text(profile.username).font(.cut_footnote)
            }
            Spacer()
            PrimaryButton(text: isFollowing ? "Unfollow" : "Follow") {
                toggleFollow()
            }
            .animation(.linear, value: isFollowing)
            .frame(maxWidth: 90)
        }.padding(.horizontal, 18)
            .onAppear(perform: {
                watch = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetProfileByIdQuery(id: profile.id), resultHandler: { result in
                    if let updatedProfile = try? result.get().data?.profileById?.fragments.profileFragment {
                        self.profile = updatedProfile
                    }
                })
            })
    }

    private func toggleFollow() {
        isFollowing.toggle()
        debouncer.debounce {
            guard isFollowing != profile.isFollowing else {
                return
            }
            inFlightRequest?.cancel()
            if profile.isFollowing {
                let mutation = CutGraphQL.UnfollowMutation(userId: profile.id)
                inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: mutation)
            } else {
                let mutation = CutGraphQL.FollowMutation(userId: profile.id)
                inFlightRequest = AuthorizedApolloClient.shared.client.perform(mutation: mutation)
            }

        }
    }
}

#Preview {
    ProfileRow(profile: Mocks.profile)
}
