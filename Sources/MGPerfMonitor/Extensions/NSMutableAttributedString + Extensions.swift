//
// NSMutableAttributedString + Extensions.swift
//
// Copyright © 2023 Chief Group Limited. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
    @discardableResult
    func setFont(_ font: UIFont) -> NSMutableAttributedString {
        let range = NSMakeRange(0, length)
        addAttribute(.font, value: font, range: range)
        return self
    }

    @discardableResult
    func setFontColor(_ color: UIColor) -> NSMutableAttributedString {
        let range = NSMakeRange(0, length)
        addAttribute(.foregroundColor, value: color, range: range)
        return self
    }

    @discardableResult
    func setParagraphSpacing(_ spacing: CGFloat, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = spacing
        paragraphStyle.alignment = alignment
        let range = NSMakeRange(0, length)
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return self
    }

    @discardableResult
    func setLineSpacing(_ lineSpacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let range = NSMakeRange(0, length)
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return self
    }
    
    @discardableResult
    func setHightColor(to textToFind: String, with color: UIColor) -> NSMutableAttributedString {
        let range = mutableString.range(of: textToFind)
        if range.location != NSNotFound {
            addAttributes([.foregroundColor: color], range: range)
        }
        return self
    }
    
    @discardableResult
    func setHightBold(to textToFind: String, font: UIFont) -> NSMutableAttributedString {
        let range = mutableString.range(of: textToFind)
        if range.location != NSNotFound {
            addAttributes([.font: font], range: range)
        }
        return self
    }
}
