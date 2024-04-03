//
//  ProfileRow.swift
//  Cut
//
//  Created by Kyle Satti on 3/23/24.
//

import SwiftUI
import Apollo
import ApolloAPI

class ProfileRowViewModel {
    var watch: Apollo.Cancellable? = nil

    deinit {
        watch?.cancel()
    }
}

struct ProfileRow: View {
    private let profile: CutGraphQL.ProfileFragment

    init(profile: CutGraphQL.ProfileFragment) {
        self.profile = profile
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
            FollowButton(profile: profile)
            .frame(maxWidth: 90)
        }.padding(.horizontal, 18)
    }
}

#Preview {
    ProfileRow(profile: Mocks.profile)
}


class FollowButtonViewModel {
    var watch: Apollo.Cancellable?

    deinit {
        watch?.cancel()
    }
}

struct FollowButton: View {
    private let debouncer = Debouncer(delay: 0.2)
    private let viewModel = FollowButtonViewModel()
    @State private(set) var isFollowing: Bool
    @State private var inFlightRequest: Apollo.Cancellable?
    @State var profile: CutGraphQL.ProfileFragment

    init(profile: CutGraphQL.ProfileFragment) {
        self.profile = profile
        self.isFollowing = profile.isFollowing
    }

    var body: some View {
        PrimaryButton(text: isFollowing ? "Unfollow" : "Follow") {
            toggleFollow()
        }
        .animation(.linear, value: isFollowing)
        .onAppear(perform: {
            viewModel.watch?.cancel()
            viewModel.watch = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetProfileByIdQuery(id: profile.id), resultHandler: { result in
                if let updatedProfile = try? result.get().data?.profileById?.asProfile {
                    profile = updatedProfile.fragments.profileFragment
                    isFollowing = updatedProfile.isFollowing
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
