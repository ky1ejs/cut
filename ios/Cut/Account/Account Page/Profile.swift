//
//  CompleteAccount.swift
//  Cut
//
//  Created by Kyle Satti on 3/14/24.
//

import SwiftUI
import Apollo

enum OtherUserState {
    case loading(CutGraphQL.ProfileFragment)
    case loaded(CutGraphQL.FullProfileFragment)
    case error(CutGraphQL.ProfileFragment, Error)

    var profile: CutGraphQL.ProfileFragment {
        switch self {
        case .loading(let profileFragment):
            return profileFragment
        case .loaded(let fullProfileFragment):
            return fullProfileFragment.fragments.profileFragment
        case .error(let profileFragment, _):
            return profileFragment
        }
    }
}

struct GenericError: Error {
    let description: String
}

enum ProfileInput {
    case profile(CutGraphQL.ProfileFragment)
    case fullProfile(CutGraphQL.FullProfileFragment)
    case completeAccount(CutGraphQL.CompleteAccountFragment)

    var profileInterface: CutGraphQL.ProfileInterfaceFragment {
        switch self {
        case .profile(let profileFragment):
            return profileFragment.fragments.profileInterfaceFragment
        case .fullProfile(let profile):
            return profile.fragments.profileInterfaceFragment
        case .completeAccount(let completeAccount):
            return completeAccount.fragments.profileInterfaceFragment
        }
    }
}

struct ProfileContainer: View {
    let profile: CutGraphQL.ProfileFragment
    @State var input: ProfileInput
    @State var error: Error?

    init(profile: CutGraphQL.ProfileFragment) {
        self.profile = profile
        _input = .init(initialValue: .profile(profile))
    }

    var body: some View {
        Profile(profile: input)
            .task {
                AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetProfileByIdQuery(id: profile.id)) { result in
                    switch result.parseGraphQL() {
                    case .success(let response):
                        if let profile = response.profileById.asProfile?.fragments.fullProfileFragment {
                            input = .fullProfile(profile)
                        } else if let account = response.profileById.asCompleteAccount?.fragments.completeAccountFragment {
                            input = .completeAccount(account)
                        } else {
                            fatalError("data missing")
                        }
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
            .errorAlert(error: $error)
    }
}

struct Profile: View {
    let profile: ProfileInput
    @State private var state = ListState.rated
    @State private var editAccount = false
    @State private var isEditingFavoriteMovies = false
    @State private var presentedContent: Content?

    enum ListState: CaseIterable, Identifiable {
        var id: Self { self }

        case rated, watchList
        var title: String {
            return switch self {
            case .watchList: "Watch List"
            case .rated: "Rated"
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ProfileHeader(profile: profile.profileInterface)
                HStack {
                    cta()
                    ShareLink(item: profile.profileInterface.share_url) {
                        Text("Share")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                Picker(selection: $state) {
                    ForEach(ListState.allCases) { s in
                        Text(s.title).tag(s)
                    }
                } label: {
                    Text("Ignored")
                }
                .pickerStyle(.segmented)
                switch state {
                case .rated:
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Favorite movies").font(.cut_title3).bold()
                            Spacer()
                            if (profile.profileInterface.isCurrentUser) {
                                Button(isEditingFavoriteMovies ? "Done" : "Edit") {
                                    isEditingFavoriteMovies.toggle()
                                }
                            }
                        }
                        switch profile {
                        case .completeAccount(let account):
                            coverShelf(content: account.favoriteContent.map { $0.fragments.contentFragment })
                        case .profile:
                            ProgressView()
                        case .fullProfile(let profile):
                            coverShelf(content: profile.favoriteContent.map { $0.fragments.contentFragment })
                        }
                    }
                case .watchList:
                    switch profile {
                    case .completeAccount(let account):
                        PosterGrid(content: account.watchList.map { $0.fragments.contentFragment })
                    case .profile:
                        ProgressView()
                    case .fullProfile(let profile):
                        PosterGrid(content: profile.watchList.map { $0.fragments.contentFragment })
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .sheet(isPresented: $editAccount, content: {
            switch profile {
            case .completeAccount(let account):
                EditAccount(user: account) {
                    editAccount = false
                }
            default:
                fatalError("tried to present edit account on another user")
            }
        })
        .sheet(item: $presentedContent, content: { m in
            NavigationStack {
                ContentDetailView(content: m)
            }
        })
    }

    func coverShelf(content: [Content]) -> some View {
        CoverShelf(
            content: content,
            contentTapped: { m in
                presentedContent = m
            },
            isEditable: profile.profileInterface.isCurrentUser, isEditing: $isEditingFavoriteMovies
        )
        .fixedSize(horizontal: false, vertical: true)
    }

    func cta() -> some View {
        ZStack {
            switch profile {
            case .profile(let profile):
                if !profile.isCurrentUser {
                    FollowButton(profile: profile)
                }
            case .fullProfile(let profile):
                if !profile.isCurrentUser {
                    FollowButton(profile: profile.fragments.profileFragment)
                }
            case .completeAccount:
                Button("Edit Profile") { editAccount = true }
            }
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

#Preview {
    NavigationStack {
        Profile(profile: .completeAccount(Mocks.completeAccount))
    }
}

//#Preview {
//    Profile(profile: .otherUser(.loading(Mocks.profile)))
//}
