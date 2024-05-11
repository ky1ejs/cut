//
//  PersonDetailView.swift
//  Cut
//
//  Created by Kyle Satti on 5/10/24.
//

import SwiftUI
import Kingfisher

struct PersonDetailView: View {
    let person: CutGraphQL.PersonInterfaceFragment
    @State var extendedPerson: CutGraphQL.ExtendedPersonFragment?
    var isLoading: Bool { extendedPerson == nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(spacing: 18) {
                    KFImage(person.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100 * 1.64)
                        .mask {
                            RoundedRectangle(cornerRadius: 10)
                        }
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.cut_title1)
                        VStack(alignment: .leading) {
                            Text(extendedPerson?.knownFor ?? .placeholder(length: 15))
                            if let birthday = extendedPerson?.birthday {
                                Text("DOB: \(Formatters.fullDF.string(from: birthday))")
                            } else {
                                Text(verbatim: .placeholder(length: 8))
                            }
                            Text(extendedPerson?.placeOfBirth ?? .placeholder(length: 12))
                        }
                        .redacted(if: isLoading)
                        .shimmering(active: isLoading)
                    }
                    Spacer()
                }
                Text("Appears In")
                    .font(.cut_title1)
                LazyVStack {
                    if let movies = extendedPerson?.works {
                        ForEach(movies, id: \.id) { m in
                            let entity = Entity(
                                id: m.id,
                                title: m.title,
                                subtitle: m.role,
                                imageUrl: m.poster_url
                            )
                            NavigationLink {
                                DetailView(content: m.fragments.movieFragment)
                            } label: {
                                EntityRow(
                                    entity: entity,
                                    accessory: SmallWatchListButton(movie: m.fragments.movieFragment)
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
                        .redacted(if: isLoading)
                        .shimmering(active: isLoading)
                    }
                }
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
    PersonDetailView(person: Mocks.personFragment, extendedPerson: nil)
}
