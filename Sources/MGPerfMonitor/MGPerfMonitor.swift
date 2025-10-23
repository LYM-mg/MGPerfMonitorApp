// The Swift Programming Language
// https://docs.swift.org/swift-book


import Foundation
import Combine
import UIKit

@available(iOS 13.0, *)
public final class MGPerfMonitor {
    nonisolated(unsafe) public static let shared = MGPerfMonitor()
    private var cancellables = Set<AnyCancellable>()
    private let combinedSubject = PassthroughSubject<(Int, Bool), Never>()
    public var combinedPublisher: AnyPublisher<(Int, Bool), Never> { combinedSubject.eraseToAnyPublisher() }
    
    private init() {
        MGFPSMonitor.shared.publisher.sink { [weak self] fps in
            guard let self = self else { return }
            self.combinedSubject.send((fps, false))
            MGPerfLogger.shared.log("FPS: \(fps)")
        }.store(in: &cancellables)
        
        MGLagMonitor.shared.publisher.sink { [weak self] duration in
            guard let self = self else { return }
            let stack = MGStackSampler.sampleMainThreadSymbolized().joined(separator: "\n")
            MGPerfLogger.shared.log("Lag \(duration)s:\n\(stack)")
            self.combinedSubject.send((MGFPSMonitor.shared.currentValue ?? 0, true))
        }.store(in: &cancellables)
    }
    
    @MainActor public func start() {
        MGFPSMonitor.shared.start()
        MGLagMonitor.shared.start()
    }
    
    @MainActor public func stop() {
        MGFPSMonitor.shared.stop()
        MGLagMonitor.shared.stop()
    }
    
    @MainActor public func showHUD() { MGPerfHUD.shared.show() }
    @MainActor public func hideHUD() { MGPerfHUD.shared.hide() }
}
