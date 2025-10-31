//
// Int+Extensions.swift
//
// Copyright © 2023 Chief Group Limited. All rights reserved.
//

import Foundation

extension Int {
    // MARK: - Tick size
    /// exchagne tick length to be format string
    /// e.g. if tickLength is 3, will return 0.001
    public var toTickSizeString: String {
        let tickSize = String(format: "%f", 1/(pow(10.0, Double(self))))
        return tickSize.removeSuffix("0")
    }

    /// convert Int to String
    public var toString: String { return description }
}

extension CGFloat {
    // MARK: - Tick size
    /// exchagne tick length to be format string
    /// e.g. if tickLength is 3, will return 0.001
    public var toTickSizeString: String {
        let tickSize = String(format: "%f", 1/(pow(10.0, self)))
        return tickSize.removeSuffix("0")
    }
}
