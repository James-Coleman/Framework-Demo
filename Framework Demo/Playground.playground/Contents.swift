import UIKit

enum DateError: Error {
    case cannotFormDate(from: String)
    case cannotCalculateAge(from: Date)
}

extension DateFormatter {
    func appDate(from string: String) throws -> Date {
        self.dateFormat = "YY-MM-dd"
        self.dateFormat
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

let bottasBirthday = "1989-08-28"
let dateFormatter = DateFormatter()

let bottasBirthdayDate = try dateFormatter.appDate(from: bottasBirthday)
try dateFormatter.appStringDate(from: bottasBirthday)

bottasBirthdayDate.isBeforeNow()
bottasBirthdayDate.isAfterNow()
try bottasBirthdayDate.ageInYears()

