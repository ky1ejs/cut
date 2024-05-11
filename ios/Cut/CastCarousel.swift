//
//  CastCarousel.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import SwiftUI

struct CastCarousel: View {
    let cast: [PersonWithRole]?
    let crew: [PersonWithRole]?
    @State var presentedPerson: Person?
    @State fileprivate var presentedPeople: IdentifiableArray<PersonWithRole>?

    var isLoading: Bool { crew == nil && crew == nil }
    
    func title() -> String {
        switch (cast, crew) {
        case (.some(let cast), .some(let crew)):
            if cast.count > 0 && crew.count == 0 {
                return "Cast"
            }
            if cast.count == 0 && crew.count > 0 {
                return "Crew"
            }
            fallthrough
        default:
            return "Cast & Crew"
        }
    }

    var body: some View {
        if (crew?.count ?? 1) > 0 || (crew?.count ?? 1) > 0 {
            VStack(alignment: .leading) {
                Text(title())
                    .font(.cut_title1)
                    .redacted(reason: isLoading ? .placeholder : [])
                    .shimmering(active: isLoading)
                ScrollView(.horizontal) {
                    LazyHStack {
                        if let cast = cast, cast.count > 0 {
                                PersonCard(
                                    title: (crew?.count ?? 1) > 0 ? "Cast" : nil,
                                    entities: cast.map(Entity.from),
                                    entityTapped: { index in
                                        presentedPerson = cast[index].fragments.personInterfaceFragment
                                    }, moreAction:  {
                                        presentedPeople = IdentifiableArray(array: cast)
                                    })
                        } else if crew == nil {
                            placeholderCard()
                        }

                        if let crew = crew, crew.count > 0 {
                                PersonCard(
                                    title: (cast?.count ?? 1) > 0 ? "Crew" : nil,
                                    entities: crew.map { c in
                                        return Entity(
                                            id: c.id,
                                            title: c.name,
                                            subtitle: c.role,
                                            imageUrl: c.imageUrl
                                        )
                                    }, entityTapped: { index in
                                        presentedPerson = crew[index].fragments.personInterfaceFragment
                                    }, moreAction:  {
                                        presentedPeople = IdentifiableArray(array: crew)
                                    })
                        } else if crew == nil {
                            placeholderCard()
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .scrollIndicators(.never)
            }
            .navigationDestination(item: $presentedPerson) { person in
                PersonDetailView(person: person)
            }
            .sheet(item: $presentedPeople) { people in
                PeopleTableView(people: people.array)
            }
        }
    }

    private func placeholderCard() -> some View {
        PersonCard(
            title: "Cast",
            entities: (0..<5).map {
                Entity(
                    id: String($0),
                    title: "blah blah blah blah",
                    subtitle: "blah blah blah blah",
                    imageUrl: nil
                )
            }
        )
        .redacted(reason: isLoading ? .placeholder : [])
        .shimmering(active: isLoading)
    }

    fileprivate struct IdentifiableArray<T>: Identifiable {
        let id = UUID()
        let array: [T]
    }
}

#Preview {
    CastCarousel(cast: nil, crew: nil)
}

#Preview {
    CastCarousel(cast: [], crew: [])
}

#Preview {
    CastCarousel(cast: [Mocks.personWithRoleFragment], crew: [Mocks.personWithRoleFragment])
}
