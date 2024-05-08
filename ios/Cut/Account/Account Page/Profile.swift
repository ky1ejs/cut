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
    case loggedInUser(CutGraphQL.CompleteAccountFragment)
    case loggedInUserError(CutGraphQL.CompleteAccountFragment, Error)
    case otherUser(OtherUserState)

    var profileInterface: CutGraphQL.ProfileInterfaceFragment {
        switch self {
        case .loggedInUser(let user), let .loggedInUserError(user, _): return user.fragments.profileInterfaceFragment
        case .otherUser(let state):
            switch state {
            case .loaded(let user): return user.fragments.profileInterfaceFragment
            case .loading(let user): return user.fragments.profileInterfaceFragment
            case .error(let user, _): return user.fragments.profileInterfaceFragment
            }
        }
    }

    var isLoggedInUser: Bool {
        switch self {
        case .loggedInUser, .loggedInUserError:
            return true
        case .otherUser:
            return false
        }
    }
}

struct Profile: View {
    @State var profile: ProfileInput
    @State var state = ListState.rated
    @State private var editAccount = false
    @State private var findContacts = false
    @State private var isEditingFavoriteMovies = false
    @State private var watch: Apollo.Cancellable?
    @State private var presentedMovie: Movie?
    @Environment(\.colorScheme) private var colorScheme

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
                if case .loggedInUser = profile {
                    HStack(spacing: 18) {
                        Spacer()
                        NavigationLink {
                            Settings()
                        } label: {
                            Image(systemName: "at")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.gray)
                        }
                        NavigationLink {
                            Settings()
                        } label: {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                ProfileHeader(profile: profile.profileInterface)
                HStack {
                    cta()
                    ShareLink(item: profile.profileInterface.share_url) {
                        Text("Share")
                    }
                    .buttonStyle(SecondaryButtonStyle(colorScheme: colorScheme))
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
                            Button(isEditingFavoriteMovies ? "Done" : "Edit") {
                                isEditingFavoriteMovies.toggle()
                            }
                        }
                        switch profile {
                        case .loggedInUser(let completeAccountFragment), let .loggedInUserError(completeAccountFragment, _):
                            coverShelf(movies: completeAccountFragment.favoriteMovies.map { $0.fragments.movieFragment })
                        case .otherUser(let otherUserState):
                            switch otherUserState {
                            case .loading:
                                ProgressView()
                            case .loaded(let fullProfileFragment):
                                coverShelf(movies: fullProfileFragment.favoriteMovies.map { $0.fragments.movieFragment })
                            case .error(_, let error):
                                Text("Error: " + error.localizedDescription)
                            }
                        }
                    }
                case .watchList:
                    switch profile {
                    case .loggedInUser(let completeAccountFragment), let .loggedInUserError(completeAccountFragment, _):
                        PosterGrid(movies: completeAccountFragment.watchList.map { $0.fragments.movieFragment })
                    case .otherUser(let otherUserState):
                        switch otherUserState {
                        case .loading:
                            ProgressView()
                        case .loaded(let fullProfileFragment):
                            PosterGrid(movies: fullProfileFragment.watchList.map { $0.fragments.movieFragment })
                        case .error(_, let error):
                            Text("Error: " + error.localizedDescription)
                        }
                    }
                }
            }

        }
        .padding(.horizontal, 24)
        .scrollBounceBehavior(.basedOnSize)
        .scrollClipDisabled()
        .sheet(isPresented: $editAccount, content: {
            switch profile {
            case let .loggedInUser(account), let .loggedInUserError(account, _) :
                EditAccount(user: account) {
                    editAccount = false
                }
            case .otherUser:
                fatalError("tried to present edit account on another user")
            }
        })
        .sheet(isPresented: $findContacts, content: {
            FindFriendsViaContacts(isPresented: $findContacts)
        })
        .sheet(item: $presentedMovie, content: { m in
            DetailView(content: m)
        })
        .task {
            watch?.cancel()
            watch = nil
            watch = AuthorizedApolloClient.shared.client.watch(query: CutGraphQL.GetProfileByIdQuery(id: profile.profileInterface.id)) { result in
                switch result.parseGraphQL() {
                case .success(let data):
                    if let completeUser = data.profileById?.asCompleteAccount {
                        profile = .loggedInUser(completeUser.fragments.completeAccountFragment)
                    } else if let otherUser = data.profileById?.asProfile {
                        self.profile = .otherUser(.loaded(otherUser.fragments.fullProfileFragment))
                    } else {
                        let error = GenericError(description: "Error loading full profile")
                        switch profile {
                        case let .loggedInUser(completeAccountFragment), let .loggedInUserError(completeAccountFragment, _):
                            profile = .loggedInUserError(completeAccountFragment, error)
                        case .otherUser(let otherUserState):
                            profile = .otherUser(.error(otherUserState.profile, error))
                        }
                    }
                case .failure(let error):
                    switch profile {
                    case let .loggedInUser(completeAccountFragment), let .loggedInUserError(completeAccountFragment, _):
                        profile = .loggedInUserError(completeAccountFragment, error)
                    case .otherUser(let otherUserState):
                        profile = .otherUser(.error(otherUserState.profile, error))
                    }
                }
            }
        }
    }

    func coverShelf(movies: [Movie]) -> some View {
        CoverShelf(movies: movies, movieTapped: { m in
            presentedMovie = m
        }, isEditing: $isEditingFavoriteMovies)
            .fixedSize(horizontal: false, vertical: true)
    }

    func cta() -> some View {
        ZStack {
            switch profile {
            case .loggedInUser,. loggedInUserError:
                Button("Edit Profile") { editAccount = true }
            case .otherUser(let state):
                FollowButton(profile: state.profile)
            }
        }
        .buttonStyle(PrimaryButtonStyle(colorScheme: colorScheme))
    }
}

#Preview {
    Profile(profile: .loggedInUser(Mocks.completeAccount))
}

#Preview {
    Profile(profile: .otherUser(.loading(Mocks.profile)))
}
