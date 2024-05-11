//
//  PeopleTableView.swift
//  Cut
//
//  Created by Kyle Satti on 5/11/24.
//

import SwiftUI

struct PeopleTableView: View {
    let people: [PersonWithRole]
    @State var selectedPerson: PersonWithRole?

    var body: some View {
        List {
            ForEach(people) { person in
                NavigationLink {
                    PersonDetailView(person: person.fragments.personInterfaceFragment)
                } label: {
                    CircleImageRow(entity: Entity.from(person))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PeopleTableView(people: (0..<15).map { _ in Mocks.personWithRoleFragment })
    }
}
