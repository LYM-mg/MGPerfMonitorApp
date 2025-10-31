//
// UICollectionViewCell+Extensions.swift
//
// Copyright © 2024 Chief Group Limited. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}
