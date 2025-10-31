//
// Collection+Extension.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import UIKit

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
public extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    subscript (safe subRange: Range<Int>) -> ArraySlice<Element> {
        
        let from = index(startIndex, offsetBy: subRange.lowerBound, limitedBy: endIndex) ?? endIndex
        let to = index(startIndex, offsetBy:  subRange.upperBound, limitedBy: endIndex) ?? endIndex
        return self[from ..< to]
    }
}
