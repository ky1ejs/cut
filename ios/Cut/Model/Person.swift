//
//  Person.swift
//  Cut
//
//  Created by Kyle Satti on 5/11/24.
//

import Foundation

typealias Person = CutGraphQL.PersonInterfaceFragment
extension Person: Identifiable {}

typealias PersonWithRole = CutGraphQL.PersonFragment
extension PersonWithRole: Identifiable {}

