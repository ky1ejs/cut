//
//  CastCarousel.swift
//  Cut
//
//  Created by Kyle Satti on 5/5/24.
//

import SwiftUI

protocol Personable {
    associatedtype InputType
    func map(_ input: InputType) -> Entity
    func person(_ input: InputType) -> Person
}

struct CastCarousel<T: Identifiable, M: Personable, TM: EntityMapper>: View where T == M.InputType, T == TM.InputType {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.theme) var theme
    let cast: [T]?
    let crew: [T]?
    let mapper: M
    let tableMapper: TM
    @State var presentedPerson: Person?
    @State fileprivate var presentedPeople: IdentifiableArray<T>?

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
                    .foregroundStyle(theme.text.color)
                ScrollView(.horizontal) {
                    LazyHStack {
                        if let cast = cast, cast.count > 0 {
                            card(for: cast, title: (crew?.count ?? 1) > 0 ? "Crew" : nil)
                        } else if crew == nil {
                            placeholderCard()
                        }

                        if let crew = crew, crew.count > 0 {
                            card(for: crew, title: (cast?.count ?? 1) > 0 ? "Cast" : nil)
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
                    .environment(\.theme, Theme.for(colorScheme))
            }
            .sheet(item: $presentedPeople) { people in
                NavigationStack {
                    TableView(
                        entites: people.array,
                        mapper: tableMapper
                    )
                }
                .environment(\.theme, Theme.for(colorScheme))
            }
        }
    }

    private func card(for entities: [T], title: String?) -> some View {
        PersonCard(
            title: title,
            entities: entities.map(mapper.map(_:)),
            entityTapped: { index in
                presentedPerson = mapper.person(entities[index])
            }, moreAction:  {
                presentedPeople = IdentifiableArray(
                    array: entities
                )
            })
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
}

fileprivate struct IdentifiableArray<T>: Identifiable {
    let id = UUID()
    let array: [T]
}

struct PersonPersonable: Personable {
    func map(_ input: PersonWithRole) -> Entity {
        Entity(
            id: input.id,
            title: input.name,
            subtitle: input.role,
            imageUrl: input.imageUrl
        )
    }
    func person(_ input: PersonWithRole) -> Person {
        input.fragments.personInterfaceFragment
    }
}

#Preview {
    CastCarousel(
        cast: nil,
        crew: nil,
        mapper: PersonPersonable(),
        tableMapper: PersonEntityMapper()
    )
}

#Preview {
    CastCarousel(
        cast: [], 
        crew: [],
        mapper: PersonPersonable(),
        tableMapper: PersonEntityMapper()
    )
}

#Preview {
    CastCarousel(
        cast: [Mocks.personWithRoleFragment],
        crew: [Mocks.personWithRoleFragment],
        mapper: PersonPersonable(),
        tableMapper: PersonEntityMapper()
    )
}
