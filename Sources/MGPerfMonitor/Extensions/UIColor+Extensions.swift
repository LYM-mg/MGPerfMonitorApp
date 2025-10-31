//
// UIColor+Extensions.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
//    static var themeColors: CHFThemeableColors {
//        ThemeManager.shared.currentTheme.colors
//    }

    static func color(from baseFolder: String, named name: String, in bundle: Bundle = Bundle.module) -> UIColor? {
        UIColor(named: "\(baseFolder)/\(name)", in: bundle, compatibleWith: nil)
    }

    static func dynamicColorWith(defaultColor: UIColor, darkColor: UIColor? = nil) -> UIColor {
        if let darkColor = darkColor {
            return UIColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? darkColor : defaultColor })
        } else {
            return defaultColor
        }
    }
    private convenience init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }

    public convenience init(rgb: Int, alpha: Int = 255) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }

    public var color: Color {
        Color(self)
    }
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }

    func getRGBFloatString()-> String {
        let result = getRGB()

        let r = result.0
        let g = result.1
        let b = result.2

        return "\(r),\(g),\(b)"
    }

    func getRGBIntString()-> String {
        let result = getRGB()

        let r = Int(result.0*255)
        let g = Int(result.1*255)
        let b = Int(result.2*255)

        return "\(r),\(g),\(b)"
    }

    func toHex() -> Int {
        let result = getRGB()

        let r = result.0
        let g = result.1
        let b = result.2
        let a = result.3

        return (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    }
    
    public func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    public func toHexFullString(_ alpha: CGFloat = 1.0) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let adjustedAlpha = max(0.0, min(alpha, 1.0))
        
        let finalR = (1 - adjustedAlpha) * 255 + adjustedAlpha * r * 255
        let finalG = (1 - adjustedAlpha) * 255 + adjustedAlpha * g * 255
        let finalB = (1 - adjustedAlpha) * 255 + adjustedAlpha * b * 255
        
        return String(
            format: "#%02X%02X%02X",
            Int(finalR),
            Int(finalG),
            Int(finalB)
        )
    }
    
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hexString)
        scanner.currentIndex = hexString.hasPrefix("#") ? scanner.string.index(after: scanner.currentIndex) : scanner.currentIndex

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension Color {
    public init(hex: Int, alpha: Int = 255) {
        self.init(UIColor(rgb: hex, alpha: alpha))
    }
}
