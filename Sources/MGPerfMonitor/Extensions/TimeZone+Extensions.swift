//
// TimeZone+Extensions.swift
//
// Copyright © 2024 Chief Group Limited. All rights reserved.
//

import Foundation

extension TimeZone {
    public static var USTimeZone: TimeZone? {
        return TimeZone(identifier: "America/New_York")
    }
    
    public static var HKTimeZone: TimeZone? {
        return TimeZone(identifier: "Asia/Hong_Kong")
    }
}
