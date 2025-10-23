//
//  File.swift
//  MGPerfMonitor
//
//  Created by 刘远明 on 2025/10/23.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public final class MGFPSMonitor {
    nonisolated(unsafe) public static let shared = MGFPSMonitor()
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var frameCount: Int = 0
    private let subject = CurrentValueSubject<Int, Never>(0)
    public var publisher: AnyPublisher<Int, Never> { subject.eraseToAnyPublisher() }
    
    private init() {}
    
    public var currentValue: Int {
        subject.value
    }
    
    public func start() {
        guard displayLink == nil else { return }
        lastTimestamp = 0
        frameCount = 0
        displayLink = CADisplayLink(target: self, selector: #selector(tick(_:)))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    public func stop() {
        displayLink?.invalidate()
        displayLink = nil
        lastTimestamp = 0
        frameCount = 0
    }
    
    @objc private func tick(_ link: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            return
        }
        frameCount += 1
        let dt = link.timestamp - lastTimestamp
        if dt >= 1.0 {
            let fps = Int(round(Double(frameCount) / dt))
            subject.send(fps)
            frameCount = 0
            lastTimestamp = link.timestamp
        }
    }
}
