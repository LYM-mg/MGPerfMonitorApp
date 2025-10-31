//
// UIWindow+Extension.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import UIKit

extension UIWindow {
    public func dismiss() {
        isHidden = true
        windowScene = nil
    }

    @available(*, deprecated, message: "Use UIView topMostController() instead")
    public static func topViewController() -> UIViewController? {
        guard let window = UIWindow.keyWindow, let rootViewController = window.rootViewController else {
          let vc = UIViewController()
         UIWindow.keyWindow?.rootViewController = vc
          return vc
        }
        var top: UIViewController? = rootViewController
        while true {
         if let presented = top?.presentedViewController {
             top = presented
         } else if let nav = top as? UINavigationController {
             top = nav.visibleViewController
         } else if let tab = top as? UITabBarController {
             top = tab.selectedViewController
         } else {
             break
         }
        }
        return top
     }
}

extension UIWindow {
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter{ $0.isKeyWindow }.first
    }

    public static var keyStatusBarManager: UIStatusBarManager? {
        return UIWindow.keyWindow?.windowScene?.statusBarManager
    }

    public static var statusBarFrame: CGRect {
        return UIWindow.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRectZero
    }

    /// iPhone 11/XR                    (48pt)
    /// iPhone 12/12 Pro/13/13 Pro/14   (47pt)
    /// iPhone 14 Pro/14 Pro Max        (59pt)
    /// iPhone other notch              (44pt)
    /// iPhone no notch                 (20pt)
    public static var statusBarHeight: CGFloat {
        return UIWindow.keyStatusBarManager?.statusBarFrame.height ?? 20
    }

    /// the safe height of window (remove - bottomPadding - topPadding)
    public static var safeAreaHeight: CGFloat {
        guard let window = UIWindow.keyWindow else {
            return 0
        }
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        return UIScreen.main.bounds.height - bottomPadding - topPadding
    }

    public static var topPadding: CGFloat {
        return UIWindow.keyWindow?.safeAreaInsets.top ?? 0
    }

    public static var bottomPadding: CGFloat {
        return UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0
    }
}
