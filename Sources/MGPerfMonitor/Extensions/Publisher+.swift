//
// Publisher+.swift
//
// Copyright © 2025 Chief Group Limited. All rights reserved.
//

import Foundation
import Combine

public extension Publisher {
    func conditionalDropFirst(_ shouldDrop: Bool) -> AnyPublisher<Self.Output, Self.Failure> {
        return shouldDrop ? dropFirst().eraseToAnyPublisher() : eraseToAnyPublisher()
    }
}
