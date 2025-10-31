//
// String+Extensions.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public func removePrefix(_ prefix: Character) -> String {
        var modifiedString = self
        while modifiedString.first == prefix {
            modifiedString.removeFirst()
        }
        return modifiedString
    }
    
    public func removeSuffix(_ str: String) -> String {
        var tempStr = self
        while tempStr.hasSuffix(str) {
            tempStr.removeLast()
        }
        return tempStr
    }

    /// Replace the designated character  & trim the rest character or remove the last character
    /// e.g. "HSI-CALL", "恆生購"  will return  "HSI",  "恆生"
    /// - Parameters:
    ///   - target: designated character
    ///   - replacement: new character
    /// - Returns: new string
    public func replaceAndTrimLast(target: String = "-", replacement: String = "\n") -> String {
        guard count > 1 else { return self }
        if let range = range(of: target) {
            let trimmedString = self[..<range.lowerBound]
            return trimmedString.replacingOccurrences(of: target, with: replacement)
        } else {
            return String(dropLast())
        }
    }

    /// fill suffix with string
    /// e.g. 
    /// 1. abc fill with 0, totalLength = 6, will return abc000
    /// 2. abcdefg fill will 0, totalLength = 6, will return abcdefg
    public func fillSuffix(with str: String, minTotalLength: Int) -> String {
        var content = self
        // special handling timestamp string is like: 1735805289.822
        if let element = components(separatedBy: ".").first {
            content = element
        }
        while content.count < minTotalLength {
            content.append(str)
        }
        return content
    }
    
    // MARK: - Date
    public func toDate(_ format: String, timeZone: TimeZone? = nil) -> Date? {
        if isEmpty { return nil }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        dateFormat.timeZone = timeZone
        return dateFormat.date(from: self)
    }

    /// Convert HK date form string
    /// - Parameter format: designated format
    /// - Returns: result date
    public func toHKDate(format: String = "yyyy-MM-dd") -> Date? {
        if isEmpty { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_HK")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC+08:00")
        return dateFormatter.date(from: self)
    }

    /// Convert time strings from one format to another
    /// - Parameters:
    ///   - fromFormat: from Format
    ///   - toFormat: to Format
    /// - Returns: new date string
    public func toDateString(fromFormat: String, toFormat : String) -> String? {
        if let date = toDate(fromFormat) {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = toFormat
            return dateFormat.string(from: date)
        }
        return nil
    }

    /// Calculates the months between two time strings
    /// The caller is the start time string
    /// - Parameter expiry: The time string to be reached
    /// - Returns: Decimal format numbers
    public func monthsBetweenDates(to expiry: String) -> Decimal? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let fromDate = dateFormatter.date(from: self),
              let toDate = dateFormatter.date(from: expiry) else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: fromDate, to: toDate)

        guard let months = components.month else {
            return nil
        }

        guard let days = components.day else {
            return nil
        }

        var roundedMonths = Int(ceil(Double(abs(months))))
        if days > 0 {
            roundedMonths += 1
        }

        return Decimal(roundedMonths)
    }

    /// Calculates the days between two time strings
    /// The caller is the start time string
    /// - Parameter expiry: The time string to be reached
    /// - Returns: Decimal format numbers
    public func daysBetweenDates(to expiry: String) -> Decimal? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let fromDate = dateFormatter.date(from: self),
              let toDate = dateFormatter.date(from: expiry) else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: fromDate, to: toDate)

        guard let days = components.day else {
            return nil
        }

        let roundedDays = Int(ceil(Double(abs(days))))
        return Decimal(roundedDays)
    }

    /// Compare two date strings in the format "yyyy-MM-dd"
    /// - Parameter date2String: the second date string
    /// - Returns: comparison result
    public func compareDates(with date2String: String) -> ComparisonResult? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let date1 = formatter.date(from: self), let date2 = formatter.date(from: date2String) {
            return date1.compare(date2)
        }
        return nil
    }

    
    // MARK: - Decimal
    
    /// calculate the number of decimal places
    /// - Returns: e.g. "0.001" will return 3
    public func decimalPlaces() -> Int {
        if contains("."), let places = components(separatedBy: ".").last?.count {
            return places
        } else {
            return 0
        }
    }
    
    ///  make decimal format
    /// - Parameter fractionDigits: decimal places
    /// - Returns: e.g. "1000" will retrun "1,000"
    public func toDecimalFormat(_ fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_HK")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        if let decimal = formatter.number(from: self) {
            return formatter.string(from: decimal) ?? self
        } else {
            return self
        }
    }
    
    public func toDoudle(digit: Int = 3) -> Double {
        if !isEmpty {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.usesGroupingSeparator = true
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            formatter.maximumFractionDigits = digit
            formatter.minimumFractionDigits = digit
            formatter.locale = Locale(identifier: "en_HK")
            if let s = formatter.number(from: (removeSeparator())) {
                return s.doubleValue
            }
        }
        return 0
    }
    
    public func toDecimal() -> NSDecimalNumber {
        return NSDecimalNumber(string: self)
    }
    
    public var asDecimal: Decimal? {
        let `self` = self.removeSeparator()
        if let _ = Double(self), let value = Decimal(string: self)  {
            return value
            
        } else if let valueWithUnit = asDecimalWithUnit {
            return valueWithUnit
            
        } else {
            return nil
        }
    }
    
    /// e.g. 1k will be 1000
    private var asDecimalWithUnit: Decimal? {
        let multiplier: Decimal
        let strippedValue: String
        
        if hasSuffix("K") {
            multiplier = 1_000
            strippedValue = replacingOccurrences(of: "K", with: "")
            
        } else if hasSuffix("M") {
            multiplier = 1_000_000
            strippedValue = replacingOccurrences(of: "M", with: "")
            
        } else {
            return Decimal(string: self)
        }
        
        guard let _ = Double(strippedValue), let value = Decimal(string: strippedValue) else { return nil }
        return value * multiplier
    }
    
    /// remove format
    /// - Returns: e.g. "1,000" will return "1000"
    public func removeSeparator() -> String {
        replacingOccurrences(of: ",", with: "")
    }
    
    
    public func calculateTextWidth(with fontSize: CGFloat, isBold: Bool = false) -> CGFloat {
        var dict: NSDictionary = NSDictionary()
        if (isBold) {
            dict = NSDictionary(object: UIFont.boldSystemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        } else {
            dict = NSDictionary(object: UIFont.systemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        }
        
        let rect: CGRect = (self as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: fontSize),
                                                           options: [NSStringDrawingOptions.truncatesLastVisibleLine,
                                                                     NSStringDrawingOptions.usesFontLeading,
                                                                     NSStringDrawingOptions.usesLineFragmentOrigin],
                                                           attributes: dict as? [NSAttributedString.Key : Any] ,
                                                           context: nil)
        return rect.size.width
    }
    
    public func calculateTextHeight(with labelWidth: CGFloat, fontSize: CGFloat, isBold: Bool = false) -> CGFloat {
        var dict: NSDictionary = NSDictionary()
        if (isBold) {
            dict = NSDictionary(object: UIFont.boldSystemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        } else {
            dict = NSDictionary(object: UIFont.systemFont(ofSize: fontSize),forKey: NSAttributedString.Key.font as NSCopying)
        }
        
        let rect: CGRect = (self as NSString).boundingRect(with: CGSize(width: labelWidth, height: CGFloat(MAXFLOAT)),
                                                           options: [NSStringDrawingOptions.truncatesLastVisibleLine,
                                                                     NSStringDrawingOptions.usesFontLeading,
                                                                     NSStringDrawingOptions.usesLineFragmentOrigin],
                                                           attributes: dict as? [NSAttributedString.Key : Any] ,
                                                           context: nil)
        return rect.size.height
    }

    public func replaceStr(_ target: String, _ withString: String) -> String {
        return replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}


// MARK: strong to attributedText
public extension String {
    func convertToHighlightAttributedText(with highlight: String?,
                                          highlightColor: UIColor? = nil,
                                          normalColor: UIColor,
                                          font: UIFont,
                                          highlightFont: UIFont? = nil) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: self, attributes: [
            .foregroundColor: normalColor,
            .font: font
        ])
        
        if let highlight = highlight, let highlightColor = highlightColor {
            var searchStartIndex = startIndex
            while let range = range(of: highlight, options: [], range: searchStartIndex..<endIndex) {
                let nsRange = NSRange(range, in: self)
                attributedText.addAttribute(.foregroundColor, value: highlightColor, range: nsRange)
                if let highlightFont = highlightFont {
                    attributedText.addAttribute(.font, value: highlightFont, range: nsRange)
                }
                searchStartIndex = range.upperBound
            }
        }
        
        return attributedText
    }
}

public extension String {
    
    func symbolWithPreZero(targetCount: Int = 5) -> String? {
        var newSymbol = self
        let diffCount = targetCount - count
        if diffCount > 0 {
            for _ in 0..<diffCount {
                newSymbol = "0" + newSymbol
            }
        }
        return newSymbol
    }

    func isInteger() -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: self) {
            let decimal = number.decimalValue
            return decimal.isInteger()
        }
        return false
    }
    
    /// extract date from string
    /// - Parameter pattern: date pattern
    /// - Returns: string
    /// e.g. if "2024-09-30T00:00:00+08:00", will return 2024-09-30
    func extractDate(withPattern pattern: String = "\\d{4}-\\d{2}-\\d{2}") -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: utf16.count)
            if let match = regex.firstMatch(in: self, options: [], range: range) {
                let dateRange = match.range(at: 0)
                if let swiftRange = Range(dateRange, in: self) {
                    return String(self[swiftRange])
                }
            }
        } catch {
            print("Failed to create regex: \(error.localizedDescription)")
        }
        return nil
    }
    
    /// timestamp convert to date
    /// e.g. 1710774517651 -> 2024-09-30
    func timestampToDate() -> Date? {
        guard let timestamp = Double(self) else { return nil }
        let divisor = count > 10 ? 1000.0 : 1.0
        return Date(timeIntervalSince1970: timestamp / divisor)
    }
   
}

// MARK: - Redis channel
public extension String {
    var getOptionSymbolComponent: String? {
        let components = components(separatedBy: "_STKOP_")
        return components.last
    }
    
    var getStockSymbolComponent: String? {
        let components = components(separatedBy: "_STK_")
        return components.last
    }
}
