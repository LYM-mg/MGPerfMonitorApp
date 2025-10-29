//
//  File.swift
//  MGPerfMonitor
//
//  Created by 刘远明 on 2025/10/23.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public final class MGLagMonitor {
    nonisolated(unsafe) public static let shared = MGLagMonitor()
    private var observer: CFRunLoopObserver?
    private let sem = DispatchSemaphore(value: 0)
    private var monitorThread: Thread?
    private var isRunning = false
    private var threshold: TimeInterval = 0.4
    private let subject = PassthroughSubject<TimeInterval, Never>()
    public var publisher: AnyPublisher<TimeInterval, Never> { subject.eraseToAnyPublisher() }
    
    private init() {}
    
    public func configure(threshold: TimeInterval) { self.threshold = threshold }
    
    public func start() {
        guard !isRunning else { return }
        isRunning = true
        
        var ctx = CFRunLoopObserverContext(version: 0,
                                           info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                                           retain: nil, release: nil, copyDescription: nil)
        observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                           CFRunLoopActivity.beforeSources.rawValue | CFRunLoopActivity.afterWaiting.rawValue,
                                           true, 0,
                                           { observer, activity, info in
            guard let info = info else { return }
            let monitor = Unmanaged<MGLagMonitor>.fromOpaque(info).takeUnretainedValue()
            monitor.sem.signal()
        }, &ctx)
        
        if let obs = observer { CFRunLoopAddObserver(CFRunLoopGetMain(), obs, .commonModes) }
        
        monitorThread = Thread(target: self, selector: #selector(watchLoop), object: nil)
        monitorThread?.start()
    }
    
    public func stop() {
        isRunning = false
        if let obs = observer { CFRunLoopRemoveObserver(CFRunLoopGetMain(), obs, .commonModes) }
        observer = nil
        monitorThread?.cancel()
        monitorThread = nil
    }
    
    @objc private func watchLoop() {
        while isRunning && !Thread.current.isCancelled {
            let res = sem.wait(timeout: .now() + threshold)
            if res == .timedOut {
                subject.send(threshold)
                // 采样主线程堆栈
                let stack = MGStackSampler.sampleMainThreadSymbolized()
                MGPerfLogger.shared.log("Lag \(threshold)s:\n" + stack.joined(separator: "\n"))
            }
            Thread.sleep(forTimeInterval: 0.02)
        }
    }
}
