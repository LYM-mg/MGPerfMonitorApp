//
// UIViewController+Extensions.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import UIKit

public extension UIViewController {
    func isModal() -> Bool {
        if presentingViewController != nil {
            if let navigationController = self as? UINavigationController, navigationController.viewControllers.first == self {
                return true
            }

            if let tabBarController = self as? UITabBarController, tabBarController.viewControllers?.first == self {
                return true
            }

            if navigationController == nil && tabBarController == nil {
                return true
            }
        }

        if let navigationController = navigationController, navigationController.viewControllers.first == self, navigationController.presentingViewController != nil {
            return true
        }
        return false
    }
    
    var isDarkMode: Bool {
        let mode = UserDefaults.displayColorsSetting.toUserInterfaceStyle
        if mode == .unspecified {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark
        } else {
            return mode == .dark
        }
    }
}

/// MARk: - Return z to the specified controller
public extension UIViewController {
     /**
      * Navigation bar returns to the specified controller
      * className: controller name (string)
      * animated: whether to have animation
      */
     func back(toController className: String!, animated: Bool) {
         guard let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
             return
         }
         let classStringName = appName + "." + className
         guard let cls:AnyClass = NSClassFromString(classStringName) else {
             return;
         }

         back(toControllerClass: cls, animated: animated)
     }

     /**
      * Navigation bar returns to the specified controller
      * cls: controller class name)
      * animated: whether to have animation
      */
     func back(toControllerClass cls: AnyClass, animated: Bool) {
         if let navigationController = navigationController {
             let firstObject = navigationController.children.filter { return $0.isKind(of: cls) }.first
             if let result = firstObject {
                  navigationController.popToViewController(result, animated: animated)
             }
         }
     }
    
    /**
     * Navigation bar returns to the specified controller
     * cls: controller class name)
     * animated: whether to have animation
     */
    func back(_ cls: AnyClass, animated: Bool) {
        if let controllers = navigationController?.viewControllers {
            for (index, controller) in controllers.enumerated().reversed() {
                if (controller.isKind(of: cls)) {
                    navigationController?.setViewControllers(Array(navigationController?.viewControllers.prefix(index+1) ?? []), animated: true)
                    break
                }
            }
        }
    }
}

public extension UIAlertController {

    func addCloseButton(icon: UIImage) {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(icon, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)

        view.addSubview(closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    @objc private func closeButtonClicked() {
        dismiss(animated: true, completion: nil)
    }

    func setMessageAlignment(_ alignment: NSTextAlignment) {
        guard let message = message else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        let attributedMessage = NSAttributedString(
            string: message,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 13)
            ]
        )

        setValue(attributedMessage, forKey: "attributedMessage")
    }
}


public extension UIViewController {
    func dismissThen(animated flag: Bool, completion: ((UIViewController?) -> Void)? = nil) {
        dismiss(animated: flag) {
            if let completion {
                completion(UIWindow.topViewController())
            }
        }
    }
}

public extension UIViewController {
//    func toast(message: String, duration: TimeInterval = 1.0) {
//        let toastLabel = CXPaddingLabel()
//        toastLabel.backgroundColor = theme.colors.bg_dim
//        toastLabel.textColor = theme.colors.txt_white
//        toastLabel.textAlignment = .center
//        toastLabel.font = theme.fonts.body
//        toastLabel.text = message
//        toastLabel.alpha = 0.0
//        toastLabel.layer.cornerRadius = 10
//        toastLabel.clipsToBounds = true
//        toastLabel.numberOfLines = 0
//        toastLabel.layer.cornerRadius = 10.0
//        toastLabel.padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//    
//        view.addSubview(toastLabel)
//        
//        toastLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            toastLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
//            toastLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
//            toastLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
//        ])
//    
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 1.0
//        }, completion: { _ in
//            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseIn, animations: {
//                toastLabel.alpha = 0.0
//            }, completion: { _ in
//                toastLabel.removeFromSuperview()
//            })
//        })
//    }
}
