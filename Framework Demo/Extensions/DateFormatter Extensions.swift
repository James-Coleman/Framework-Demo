//
//  DateFormatter Extensions.swift
//  Framework Demo
//
//  Created by James Coleman on 11/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation

extension DateFormatter {
    func appDate(from string: String) throws -> Date {
        self.dateFormat = "YY-MM-dd"
        guard let date = date(from: string) else { throw DateError.cannotFormDate(from: string) }
        return date
    }
    
    func appStringDate(from string: String) throws -> String {
        let date = try appDate(from: string)
        
        self.dateStyle = .long
        self.timeStyle = .none
        
        return self.string(from: date)
    }
}
