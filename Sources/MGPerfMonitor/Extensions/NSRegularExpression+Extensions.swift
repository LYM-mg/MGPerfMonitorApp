//
// NSRegularExpression+Extensions.swift
//
// Copyright © 2023 Chief Group Limited. All rights reserved.
//

import Foundation

/// Regular matching
/// - Parameters:
///   - regex: matching rules
///   - validateString: target string
/// - Returns: match result
public func RegularExpression(regex:String, validateString:String) -> [String]{
    do {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regex, options: [])
        let matches = regex.matches(in: validateString, options: [], range: NSMakeRange(0, validateString.count))
        var data:[String] = Array()
        for item in matches {
            let string = (validateString as NSString).substring(with: item.range)
            data.append(string)
        }
        
        return data
    }
    catch {
        return []
    }
}
