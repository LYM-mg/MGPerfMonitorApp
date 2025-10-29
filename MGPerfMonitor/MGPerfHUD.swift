//
//  File.swift
//  MGPerfMonitor
//
//  Created by 刘远明 on 2025/10/23.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public final class MGPerfHUD: UILabel {
    @MainActor public static let shared = MGPerfHUD()
    private var cancellables = Set<AnyCancellable>()
    private var panGesture: UIPanGestureRecognizer!
    private var isShown = false
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 12, y: 80, width: 120, height: 32)
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        textColor = .white
        font = UIFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        layer.cornerRadius = 6
        layer.masksToBounds = true
        textAlignment = .center
        alpha = 0.9
        isUserInteractionEnabled = true
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    public required init?(coder: NSCoder) { super.init(coder: coder) }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: superview)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            sender.setTranslation(.zero, in: superview)
        }
    }
    
    public func show(in window: UIWindow? = UIApplication.shared.windows.first) {
        guard !isShown else { return }
        isShown = true
        if let w = window { w.addSubview(self) }
        subscribe()
        MGPerfMonitor.shared.start()
    }
    
    public func hide() {
        removeFromSuperview()
        isShown = false
        cancellables.removeAll()
    }
    
    private func subscribe() {
        let fpsPub = MGFPSMonitor.shared.publisher
        let lagPub = MGLagMonitor.shared.publisher
        fpsPub.combineLatest(lagPub.prepend(0.0))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fps, lag in
                guard let self = self else { return }
                self.text = "FPS:\(fps) \(lag>0 ? "⚠️" : "")"
                self.textColor = lag>0 ? .red : (fps>50 ? .green : .orange)
            }.store(in: &cancellables)
    }
}
