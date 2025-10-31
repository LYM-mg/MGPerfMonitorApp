//
// UIStackView+Extension.swift
//
// Copyright © 2024 Chief Group Limited. All rights reserved.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviewWithoutAnimation(_ view: UIView) {
        UIView.performWithoutAnimation {
            self.addArrangedSubview(view)
        }
    }
    
    public func removeArrangedSubviewWithoutAnimation(_ view: UIView) {
        UIView.performWithoutAnimation {
            self.removeArrangedSubview(view)
        }
    }

    public func insertArrangedSubviewWithoutAnimation(_ view: UIView, at stackIndex: Int) {
        UIView.performWithoutAnimation {
            self.insertArrangedSubview(view, at: stackIndex)
        }
    }

}
