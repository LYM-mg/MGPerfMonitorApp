//
// Decimal+Extensions.swift
//
// Copyright © 2024 Chief Group Limited. All rights reserved.
//

import Foundation

public extension Decimal {

    // MARK: - init

    /// init with String?
    init?(nullableString: String?) {
        guard let str = nullableString, let d = Decimal(string: str) else {
            return nil
        }
        self = d
    }
    
    /// ToString
    /// e.g. if 300 , will return "300"; if 3000, will return "3000"
    func toString() -> String {
        NSDecimalNumber(decimal: self).stringValue
    }

    /// Convert to a Int string or a Add 0 string with places (group with ",")
    ///  e.g. if places = 5, Decimal(27) , will return "27"
    ///  e.g. if places = 5, Decimal(27.689) , will return "27.68900"
    /// - Parameter places: number of decimal
    /// - Returns: String
    func toIntOrExtendString(expect places: Int) -> String {
       if isWholeNumber {
           return decimalToString(decimalPlace: 0)
       } else {
           return decimalToString(decimalPlace: places)
       }
   }

    /// The missing 0 needs to be added
    /// e.g. if "100" with zeroPlace: 3,  will return "100.000"
    /// - Parameter zeroPlace: need add 0 places default is 0
    /// - Returns: result string ("Nan" if error)
    func toString(zeroPlace: UInt8 = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_HK")
        numberFormatter.minimumFractionDigits = Int(zeroPlace)
        numberFormatter.maximumFractionDigits = Int(zeroPlace)
        return numberFormatter.string(from: self as NSDecimalNumber) ?? "Nan"
    }

    func toGroupingString(zeroPlace: UInt8 = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_HK")
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.minimumFractionDigits = Int(zeroPlace)
        numberFormatter.maximumFractionDigits = Int(zeroPlace)

        return numberFormatter.string(from: self as NSDecimalNumber) ?? "Nan"
    }

    /// ToFormatString
    /// e.g.
    /// if 300 , will return "300"; if 300, will return "3,000"
    func toFormatString(_ fractionDigits: Int = 0) -> String {
        NSDecimalNumber(decimal: self).toString(fractionDigits)
    }
    
    func toInt() -> Int {
        // added roundedDown logic for: if value is decimal, will return 1
        // e.g. 4.5 will 1
        return Int(truncating: NSDecimalNumber(decimal: roundedDown(0)))
    }

    /// Determines whether a Decimal is an integer,  such as 188.01 vs 188.00 -> false
    var isWholeNumber: Bool {
        let decimalNumber = NSDecimalNumber(decimal: self)
        let intValue = decimalNumber.intValue
        return self == Decimal(intValue)
   }

    func decimalToString(decimalPlace: Int, miniDigits: Int? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_HK")
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = miniDigits ?? decimalPlace
        formatter.maximumFractionDigits = decimalPlace
        formatter.minimumIntegerDigits = 1
        return formatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
    }
    
    func isInteger() -> Bool {
        var selfValue = self
        var roundedValue = Decimal()
        NSDecimalRound(&roundedValue, &selfValue, 0, .plain)
        return self == roundedValue
    }

    enum CurrencySymbol: String {
        case HKD = "HK$"
        case USD = "$"
        case CNY = "¥"
        case UNKONW = ""
    }

    func toCurrencyString(currency: CurrencySymbol, place: Int) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = place
        formatter.minimumFractionDigits = place
        switch currency {
        case .HKD:
            formatter.currencySymbol = currency.rawValue
            formatter.locale = Locale(identifier: "zh_HK")
        case .USD:
            formatter.currencySymbol = currency.rawValue
            formatter.locale = Locale(identifier: "en_US")
        case .CNY:
            formatter.currencySymbol = currency.rawValue
            formatter.locale = Locale(identifier: "zh_CN")
        case .UNKONW:
            break
        }
        formatter.roundingMode = .halfUp
        return formatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
    }

}

public extension Decimal {
    // Specified number of decimal places
    func rounded(toPlaces places: Int) -> Decimal {
        var decimalValue = self
        var result = Decimal()
        NSDecimalRound(&result, &decimalValue, places, .plain)
        return result
    }

    /// Formatted & add a suffix "+" / "-"  & add 0 for a decimal
    /// - Parameters:
    ///   - showSign: show sign "+" / "-"
    ///   - zeroSign: zero sign default is ""
    ///   - zeroPlace: need add 0 places default is 0
    /// - Returns: result string
    func formattedString(showSign: Bool = false, zeroSign: String = "", zeroPlace: UInt8 = 0) -> String {
        if !showSign {
          return toString(zeroPlace: zeroPlace).replaceStr("-", "").replaceStr("+", "")
        }
        if self > 0, !toString(zeroPlace: zeroPlace).contains("+") {
          return "+" + toString(zeroPlace: zeroPlace)
        }
        if self < 0, !toString(zeroPlace: zeroPlace).contains("-") {
          return "-" + toString(zeroPlace: zeroPlace)
        }
        if self == 0 {
          return zeroSign + toString(zeroPlace: zeroPlace)
        }
        return toString(zeroPlace: zeroPlace)
    }

    func formattedGroupingString(showSign: Bool = false, zeroSign: String = "", zeroPlace: UInt8 = 0) -> String {
        let formattedValue = toGroupingString(zeroPlace: zeroPlace)
        if !showSign {
            return formattedValue.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+", with: "")
        }
        if self > 0, !formattedValue.contains("+") {
            return "+" + formattedValue
        }
        if self < 0, !formattedValue.contains("-") {
            return "-" + formattedValue
        }
        if self == 0 {
            return zeroSign + formattedValue
        }
        return formattedValue
    }

    /// Specified number of decimal places, such as 0.1 -> 1 -> 1.23-> 2 ...
    /// - Parameter places: number of decimal
    /// - Returns: Decimal
    func roundedUP(toPlaces places: Int) -> Decimal {
       var decimalValue = self
       var result = Decimal()
       NSDecimalRound(&result, &decimalValue, places, .up)
       return result
    }
    
    /// Specified number of decimal places
    /// e.g. 0.999, if places is 0, return 0, if places is 1, return 0.9,  if places is 2, return 0.99
    /// e.g. -0.999, if places is 0, return 0 , if places is 1, return -0.9, if places is 2, return -0.99
    /// - Parameter places: number of decimal
    /// - Returns: Decimal
    func roundedDown(_ places: Int) -> Decimal {
        var decimalValue = self
        var result = Decimal()
        let mode: NSDecimalNumber.RoundingMode = (self >= Decimal(0)) ? .down : .up
        NSDecimalRound(&result, &decimalValue, places, mode)
        return result
    }
    
    func roundedDownString(_ places: Int, format: Bool = true) -> String {
        if format {
            let roundedValue = roundedDown(places)
            return roundedValue.toFormatString(places)
        }
        return "\(roundedDown(places))"
    }

    /// Accuracy may be lost, so use with caution
     var intValue: Int {
         return NSDecimalNumber(decimal: self).intValue
     }

    /// Accuracy may be lost, so use with caution
     var floatValue: Float {
         return NSDecimalNumber(decimal: self).floatValue
     }

    /// Accuracy may be lost, so use with caution
     var doubleValue: Double {
         return NSDecimalNumber(decimal: self).doubleValue
     }
    
    /// Calculate remainder
    /// e.g. 10%3 = 1
    func modulus(dividingBy divisor: Decimal) -> Decimal {
        let dividend = self
        let quotient = (dividend / divisor).roundedDown(0)
        let product = quotient * divisor
        return dividend - product
    }
}

public extension Decimal {
    func formattedWithUnits(_ maxDigits: Int = 2, minDigits: Int? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxDigits
        formatter.minimumFractionDigits = minDigits ?? maxDigits

        var result = ""
        if self >= Decimal(1_000_000_000_000) {
            let value = self / Decimal(1_000_000_000_000)
            if let formattedValue = formatter.string(from: value as NSNumber) {
                result = formattedValue + "T" // Trillion
            }
        } else if self >= Decimal(1_000_000_000) {
            let value = self / Decimal(1_000_000_000)
            if let formattedValue = formatter.string(from: value as NSNumber) {
                result = formattedValue + "B" // Billion
            }
        } else if self >= Decimal(1_000_000) {
            let value = self / Decimal(1_000_000)
            if let formattedValue = formatter.string(from: value as NSNumber) {
                result = formattedValue + "M" // Million
            }
        } else if self >= Decimal(1_000) {
            let value = self / Decimal(1_000)
            if let formattedValue = formatter.string(from: value as NSNumber) {
                result = formattedValue + "K" // Thousand
            }
        } else {
            if let formattedValue = formatter.string(from: self as NSNumber) {
                result = formattedValue
            }
        }

        return result
    }
}



extension Double {

    static var FLT_EPSILON: Double {
        1.192092896e-07
    }

    func map(from: ClosedRange<Self>, to: ClosedRange<Self>, clamp: Bool = true) -> Self {
        let inputMin = from.lowerBound
        let inputMax = from.upperBound
        let outputMin = to.lowerBound
        let outputMax = to.upperBound
        
        if (abs(inputMin - inputMax) < Double.FLT_EPSILON) {
            return outputMin
        } else {
            var outVal = ((self - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin)
            
            if(clamp) {
                if(outputMax < outputMin) {
                    if( outVal < outputMax ) { outVal = outputMax }
                    else if( outVal > outputMin ) { outVal = outputMin }
                } else {
                    if( outVal > outputMax ) { outVal = outputMax }
                    else if( outVal < outputMin ) { outVal = outputMin }
                }
            }
            return outVal
        }
        
        
    }
}
extension Comparable {
    
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#if swift(<5.1)
extension Strideable where Stride: SignedInteger {
    func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
#endif

