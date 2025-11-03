//
//  Combine+Extensions.swift
//  ChiefMT
//
//  Created by james_kong on 19/5/2022.
//

import Combine


func ignoreNil<T>(_ value: T?) -> AnyPublisher<T, Never> {
    value.map { Just($0).eraseToAnyPublisher()} ?? Empty().eraseToAnyPublisher()
}
