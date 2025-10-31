//
//  File.swift
//  MobileDesign
//
//  Created by Renzhong Xu on 2025/3/19.
//

import Foundation
import UIKit

public extension UserDefaults {
    
    static var displayColorsSetting: DisplayColorsSetting {
        get {
            guard let settingStr = UserDefaults.standard.string(forKey: "DisplayColorsSetting") else {
                return DisplayColorsSetting.system
            }
            
            return DisplayColorsSetting(storeValue: settingStr)
        }
        set {
            UserDefaults.standard.set(newValue.storeValue, forKey: "DisplayColorsSetting")
            UserDefaults.standard.synchronize()
        }
    }

}

public enum DisplayColorsSetting: Int {
    
    case light = 0
    case dark = 1
    case system = 2
    
    public var storeValue: String {
        switch self {
        case .light:
            return "LT"
        case .dark:
            return "DK"
        case .system:
            return "SYS"
        }
    }
    
    public var toUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .unspecified
        }
    }
    
    public init(storeValue: String) {
        switch storeValue {
        case "LT":
            self = .light
        case "DK":
            self = .dark
        case "SYS":
            self = .system
        default:
            self = .system
        }
    }
    
}
