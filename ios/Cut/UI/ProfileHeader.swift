//
//  ProfileHeader.swift
//  Cut
//
//  Created by Kyle Satti on 3/18/24.
//

import SwiftUI

struct ProfileHeader: View {
    let profile: CutGraphQL.ProfileInterfaceFragment
    @Environment(\.openURL) private var openURL

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name).font(.cut_title3.bold())
                    Text(profile.username).font(.cut_footnote)
                    Text(profile.bio ?? "").font(.cut_footnote)
                }
                Spacer(minLength: 18)
                HStack(spacing: 10) {
                    NavigationLink {
                        Text("")
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(profile.followerCount)").font(.cut_footnote).bold()
                            Text("follower\(profile.followerCount > 1 ? "s" : "")").font(.cut_footnote)
                        }
                    }
                    if let url = formattedProfileUrl {
                        Circle().frame(width: 6, height: 6)
                        Button {
                            openURL(url.0)
                        } label: {
                            Text(url.1)
                                .font(.cut_footnote)
                                .lineLimit(1)
                        }
                    }
                }
            }
            Spacer()
            ProfileImage()
        }.fixedSize(horizontal: false, vertical: true)
    }

    var formattedProfileUrl: (URL, String)? {
        guard let url = profile.bio_url else  {
            return nil
        }

        return (
            url,
            "\(url.host()!)\(url.path())"
        )
    }
}

#Preview {
    ProfileHeader(profile: Mocks.profileInterface)
        .padding(.horizontal, 18)
}
