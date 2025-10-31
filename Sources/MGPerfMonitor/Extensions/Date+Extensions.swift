//
// Date+Extensions.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import Foundation

extension Date {
    public static func dateDayIntervalSinceNow(_ days: Int) -> Date {
        return Date(timeIntervalSinceNow: TimeInterval(24 * 60 * 60 * days))
    }

    /// Calculate a new date based on specified date
    /// - Parameters:
    ///   - month: specified month
    ///   - week: specified week
    ///   - day: specified day
    /// - Returns: new date
    public func dateFromCalculateWith(month: Int = 0, week: Int = 0, day: Int = 0) -> Date? {
        let calender = NSCalendar.init(calendarIdentifier: .gregorian)
        var comps = DateComponents()
        comps.month = month
        comps.day = week * 7 + day
        return calender?.date(byAdding: comps, to: self)
    }

    public func changeWith(month: Int = 0, week: Int = 0, day: Int = 0) -> Date? {
        let calendar = Calendar.current
        guard let dateAfterMonthAdjustment = calendar.date(byAdding: .month, value: month, to: self) else { return nil }
        guard let dateAfterWeekAdjustment = calendar.date(byAdding: .weekOfYear, value: week, to: dateAfterMonthAdjustment) else { return nil }
        let finalAdjustedDate = calendar.date(byAdding: .day, value: day, to: dateAfterWeekAdjustment)
        return finalAdjustedDate
    }

    public func dateCompare(with other: Date, dateUnit: Calendar.Component = .day) -> Bool {
        return Calendar.current.isDate(self, equalTo: other, toGranularity: dateUnit)
    }

    public func isToday() -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }

    public func isUSToday() -> Bool {
        var calendar = Calendar.current
        if let timeZone = TimeZone.USTimeZone {
            calendar.timeZone = timeZone
        }
        return calendar.isDateInToday(self)
    }

    public func isHKToday() -> Bool {
        var calendar = Calendar.current
        if let timeZone = TimeZone.HKTimeZone {
            calendar.timeZone = timeZone
        }
        return calendar.isDateInToday(self)
    }

    /// Convert date to string with format
    /// - Parameter format: format string
    /// - Returns: date string
    public func toHKDateString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_HK")
        formatter.timeZone = TimeZone(abbreviation: "UTC+8")
        return formatter.string(from: self)
    }
    
    /// Convert date to string with format
    /// - Parameter format: format string
    /// - Returns: date string
    public func formatString(_ format: String = "yyyy-MM-dd", timeZone: TimeZone?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_HK")
        return formatter.string(from: self)
    }

    /// Convert date to date string with format
    /// - Parameter format: format string
    /// - Returns: new date
    public func toHKDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateString = toHKDateString(format: format)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_HK")
        formatter.timeZone = TimeZone(abbreviation: "UTC+8")
        return formatter.date(from: dateString)
    }
}


extension Date {
    public func copyFields(from sourceDate: Date, fields: [Calendar.Component]) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        let sourceComponents = calendar.dateComponents(Set(fields), from: sourceDate)
        
        for field in fields {
            switch field {
            case .hour:
                components.hour = sourceComponents.hour
            case .minute:
                components.minute = sourceComponents.minute
            case .second:
                components.second = sourceComponents.second
            default:
                break
            }
        }
        return calendar.date(from: components) ?? self
    }
}
