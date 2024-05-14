//
//  PeopleTableView.swift
//  Cut
//
//  Created by Kyle Satti on 5/11/24.
//

import SwiftUI

protocol EntityMapper {
    associatedtype InputType
    associatedtype PresentedView: View
    func map(_ input: InputType) -> Entity
    @ViewBuilder
    func presentedView(_ input: InputType) -> PresentedView
}

struct TableView<T: Identifiable, M: EntityMapper>: View where T == M.InputType {
    let entites: [T]
    let mapper: M
    @State var selectedPerson: T?

    var body: some View {
        List {
            ForEach(entites) { e in
                NavigationLink {
                    mapper.presentedView(e)
                } label: {
                    CircleImageRow(entity: mapper.map(e))
                }
            }
        }
    }
}

struct PersonEntityMapper: EntityMapper {
    func map(_ input: PersonWithRole) -> Entity {
        Entity(
            id: input.id,
            title: input.name,
            subtitle: input.role,
            imageUrl: input.imageUrl
        )
    }
    
    func presentedView(_ input: PersonWithRole) -> PersonDetailView {
        PersonDetailView(person: input.fragments.personInterfaceFragment)
    }
}

#Preview {
    NavigationStack {
        TableView(
            entites: (0..<15).map { _ in Mocks.personWithRoleFragment },
            mapper: PersonEntityMapper()
        )
    }
}
