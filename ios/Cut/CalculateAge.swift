//
//  CalculateAge.swift
//  Cut
//
//  Created by Kyle Satti on 5/12/24.
//

import Foundation

func calculateAge(birthDate: Date) -> Int {
    let calendar = Calendar.current
    let currentDate = Date()
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
    let age = ageComponents.year ?? 0
    return age
}
