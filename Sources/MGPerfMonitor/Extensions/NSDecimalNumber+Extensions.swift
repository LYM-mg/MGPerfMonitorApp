//
// NSDecimalNumber+Extensions.swift
//
// Copyright © 2023 Chief Group Limited. All rights reserved.
//

import Foundation

public extension NSDecimalNumber {
    // MARK: Operation
    static func + (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        lhs.adding(rhs)
    }
    static func - (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        lhs.subtracting(rhs)
    }
    static func * (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        lhs.multiplying(by: rhs)
    }
    static func / (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        lhs.dividing(by: rhs)
    }
    
    // MARK: Compare
    static func > (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        lhs.compare(rhs) == .orderedDescending
    }
    static func >= (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        if lhs.compare(rhs) == .orderedSame || lhs.compare(rhs) == .orderedDescending {
            return true
        } else {
            return false
        }
    }
    static func < (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }
    static func <= (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> Bool {
        if lhs.compare(rhs) == .orderedSame || lhs.compare(rhs) == .orderedAscending {
            return true
        } else {
            return false
        }
    }
    
    // MARK: to String
    func toString(with tickSize: Decimal?) -> String {
        let tkSize = tickSize ?? Decimal(0.01)
        let tkStr = "\(tkSize)"
        let fractionDigits = tkStr.decimalPlaces()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.locale = Locale(identifier: "en_HK")
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    func toString(_ fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.locale = Locale(identifier: "en_HK")
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
