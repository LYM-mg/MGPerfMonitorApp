//
//  PanModalPresentableNavigationController.swift
//  ChiefMT
//
//  Created by james_kong on 2/6/2022.
//

import UIKit
//import PanModal
//
//class PanModalPresentableNavigationController: UINavigationController, PanModalPresentable {
//    typealias ViewControllerPresentable = PanModalPresentable & UIViewController
//
//    init(presentable: ViewControllerPresentable) {
//        super.init(nibName: nil, bundle: nil)
//        viewControllers = [presentable]
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError()
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return topViewController?.preferredStatusBarStyle ?? .lightContent
//    }
//
//    override func popViewController(animated: Bool) -> UIViewController? {
//        let vc = super.popViewController(animated: animated)
//        panModalSetNeedsLayoutUpdate()
//        return vc
//    }
//
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        super.pushViewController(viewController, animated: animated)
//        panModalSetNeedsLayoutUpdate()
//    }
//
//    // MARK: - Pan Modal Presentable
//
//    var panScrollable: UIScrollView? {
//        return (topViewController as? PanModalPresentable)?.panScrollable
//    }
//
//    var longFormHeight: PanModalHeight {
//        return (topViewController as? PanModalPresentable)?.longFormHeight ?? .maxHeight
//    }
//
//    var shortFormHeight: PanModalHeight {
//        return (topViewController as? PanModalPresentable)?.shortFormHeight ?? longFormHeight
//    }
//    
//    var showDragIndicator: Bool {
//        return (topViewController as? PanModalPresentable)?.showDragIndicator ?? true
//    }
//}
