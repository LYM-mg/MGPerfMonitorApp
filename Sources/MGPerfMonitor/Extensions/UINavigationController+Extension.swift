//
// UINavigationController+Extension.swift
//
// Copyright © 2024 Chief Group Limited. All rights reserved.
//

import UIKit

extension UINavigationController {
    public func setNavigationBar(_ color: UIColor? = nil) {
        let appearance = UINavigationBarAppearance()

        appearance.backgroundColor =  color ?? UIColor.clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.tintColor = .black

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    public func configNavigationBar(_ textAttributes: [NSAttributedString.Key: Any], backgroundColor: UIColor? ) {
        let currentAppearance = navigationController?.navigationBar.standardAppearance ?? UINavigationBarAppearance()
        currentAppearance.configureWithOpaqueBackground()
        currentAppearance.titleTextAttributes = textAttributes as [NSAttributedString.Key: Any]
        if let color = backgroundColor {
            currentAppearance.backgroundEffect = nil
            currentAppearance.backgroundColor = color
            currentAppearance.shadowImage = UIImage()
            currentAppearance.shadowColor = .clear
        }
        navigationBar.scrollEdgeAppearance = currentAppearance
        navigationBar.standardAppearance = currentAppearance
        navigationBar.compactAppearance = currentAppearance
    }
}

extension UINavigationBar {

    public func hideBottomDividingLine() {
        let shadowImg: UIImageView? = findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = true
    }

    public func showBottomDividingLine() {
        let shadowImg: UIImageView? = findNavLineImageViewOn(view: self)
        shadowImg?.isHidden = false
    }

    // MARK: -
    fileprivate func findNavLineImageViewOn(view: UIView) -> UIImageView? {
        if (view.isKind(of: UIImageView.classForCoder()) && view.bounds.size.height <= 1.0) {
            return view as? UIImageView
        }
        for subView in view.subviews {
            let imageView = findNavLineImageViewOn(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }
}
