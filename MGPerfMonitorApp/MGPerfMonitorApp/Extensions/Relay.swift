//
//  Relay.swift
//  ChiefMT
//
//  Created by james_kong on 23/5/2022.
//

import Combine
import UIKit

class Relay<SubjectType: Subject>:
    Publisher,
    CustomCombineIdentifierConvertible where SubjectType.Failure == Never {
    typealias Output = SubjectType.Output
    typealias Failure = SubjectType.Failure
    let subject: SubjectType
    init(subject: SubjectType) {
        self.subject = subject
    }
    func send(_ value: Output) {
        subject
            .send(value)
    }
    func receive<S: Subscriber>(subscriber: S)
    where Failure == S.Failure, Output == S.Input {
        subject
            .subscribe(on: DispatchQueue.main)
            .receive(subscriber: subscriber)
    }
}
typealias CurrentValueRelay<Output> = Relay<CurrentValueSubject<Output, Never>>
typealias PassthroughRelay<Output> = Relay<PassthroughSubject<Output, Never>>
extension Relay {
    convenience init<O>(_ value: O)
    where SubjectType == CurrentValueSubject<O, Never> {
        self.init(subject: CurrentValueSubject(value))
    }
    convenience init<O>()
    where SubjectType == PassthroughSubject<O, Never> {
        self.init(subject: PassthroughSubject())
    }
}
