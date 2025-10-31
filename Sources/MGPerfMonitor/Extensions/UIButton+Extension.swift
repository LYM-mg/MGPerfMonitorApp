//
// UIButton+Extension.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import UIKit

extension UIButton {
    // MARK: - Handle UI
    public func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        setBackgroundImage(image(withColor: color), for: state)
    }
    
    public func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        alpha = isEnabled ? 1.0 : 0.5
    }
}
