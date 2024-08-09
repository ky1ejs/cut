//
//  PersonDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 5/10/24.
//

import SwiftUI
import Kingfisher

struct PersonDetailView: View {
    @Environment(\.theme) var theme
    let person: CutGraphQL.PersonInterfaceFragment
    @State var extendedPerson: CutGraphQL.ExtendedPersonFragment?
    var isLoading: Bool { extendedPerson == nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 18) {
                    PosterImage(url: extendedPerson?.imageUrl)
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.cut_title1)
                        VStack(alignment: .leading) {
                            Text("Known for: ").fontWeight(.regular) + Text(extendedPerson?.knownFor ?? .placeholder(length: 15)).bold()
                            if let birthday = extendedPerson?.birthday {
                                Text("Born: ").fontWeight(.regular) +
                                Text("\(Formatters.fullDF.string(from: birthday)) (\(calculateAge(birthDate: birthday)))")
                                    .bold()
                            } else {
                                Text(verbatim: .placeholder(length: 8))
                            }
                            Text("Birth place: ").fontWeight(.regular) + Text(extendedPerson?.placeOfBirth ?? .placeholder(length: 12)).bold()
                        }
                        .font(.cut_subheadline)
                        .foregroundStyle(theme.subtitle.color)
                        .redacted(if: isLoading)
                        .shimmering(active: isLoading)
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 22) {
                    LongText(extendedPerson?.biography ?? .placeholder(length: 150))
                        .multilineTextAlignment(.center)
                    Text("Appears In")
                        .font(.cut_title1)
                    LazyVStack {
                        if let content = extendedPerson?.works {
                            ForEach(content, id: \.id) { c in
                                let entity = Entity(
                                    id: c.id,
                                    title: c.title,
                                    subtitle: c.role,
                                    imageUrl: c.poster_url
                                )
                                NavigationLink {
                                    ContentDetailView(content: c.fragments.contentFragment)
                                } label: {
                                    EntityRow(
                                        entity: entity,
                                        accessory: SmallWatchListButton(content: c.fragments.contentFragment)
                                    )
                                }
                            }
                        } else {
                            ForEach(0..<10, id: \.self) { i in
                                let entity = Entity(
                                    id: String(i),
                                    title: .placeholder(length: 10),
                                    subtitle: .placeholder(length: 5),
                                    imageUrl: nil
                                )
                                EntityRow(entity: entity)
                            }
                        }
                    }
                }
                .redacted(if: isLoading)
                .shimmering(active: isLoading)
            }
            .padding(.horizontal, 18)
        }
        .scrollBounceBehavior(.basedOnSize)
        .onAppear {
            AuthorizedApolloClient.shared.client.fetch(query: CutGraphQL.GetPersonQuery(id: person.id)) { result in
                switch result.parseGraphQL() {
                case .success(let result):
                    extendedPerson = result.person.fragments.extendedPersonFragment
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    PersonDetailView(person: Mocks.personFragment, extendedPerson: Mocks.extendedPerson)
}

#Preview {
    PersonDetailView(person: Mocks.personFragment, extendedPerson: nil)
}
