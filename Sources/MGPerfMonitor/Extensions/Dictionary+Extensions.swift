//
// Dictionary+Extensions.swift
//
// Copyright © 2023 Chief Group Limited. All rights reserved.
//

import Foundation

public extension Dictionary {
    func intValue(forKey key: String) -> Int? {
        if let value = self[key as! Key] {
            if let intValue = value as? Int {
                return intValue
            } else if let stringValue = value as? String, let intValue = Int(stringValue) {
                return intValue
            }
        }
        return nil
    }
    
    func stringValue(forKey key: String) -> String? {
        if let value = self[key as! Key] {
            if let stringValue = value as? String {
                return stringValue
            } else if let intValue = value as? Int {
                return String(intValue)
            }
        }
        return nil
    }
}
