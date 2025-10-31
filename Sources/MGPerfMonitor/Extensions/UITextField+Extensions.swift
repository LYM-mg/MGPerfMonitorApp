//
// UITextField+Extensions.swift
//
// Copyright © 2023 Chief Group Limited. All rights reserved.
//

import UIKit

@MainActor private var maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable public var maxTextLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }

    @objc func limitLength(_ textField: UITextField) {
        guard let maxLength = maxLengths[self] else {
            return
        }
        guard let text = textField.text else {
            return
        }

        if text.count > maxLength {
            let endIndex = text.index(text.startIndex, offsetBy: maxLength)
            textField.text = String(text[..<endIndex])
        }
    }
}
