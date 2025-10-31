//
// UIDevice+Extension.swift
//
// Copyright © 2024 Chief Group Limited. All rights reserved.
//

import UIKit
import DeviceKit

extension UIDevice {
    /// iPhone is X type iPhone?
    public static var isNotch: Bool {
        return UIWindow.statusBarHeight > 20
    }

    /// judge current iphone is SE. || is simulator
    public func isiPhoneSE() -> Bool {
        return Device.current == .iPhoneSE || Device.current == .iPhoneSE2 || Device.current == .iPhoneSE3 || (modelName == "x86_64" && name.contains("iPhone SE"))
    }

    public var modelName: String? {
        var systemInfo = utsname()
        uname(&systemInfo)

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

}
