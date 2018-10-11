//
//  Date Extensions.swift
//  Framework Demo
//
//  Created by James Coleman on 11/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation

enum DateError: Error {
    case cannotFormDate(from: String)
    case cannotCalculateAge(from: Date)
}

extension Date {
    func isBeforeNow() -> Bool {
        let now = Date()
        return self.compare(now) == .orderedAscending
    }
    
    func isAfterNow() -> Bool {
        let now = Date()
        return self.compare(now) == .orderedDescending
    }
    
    func ageInYears() throws -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.year], from: self, to: Date())
        guard let year = components.year else { throw DateError.cannotCalculateAge(from: self) }
        return year
    }
}
