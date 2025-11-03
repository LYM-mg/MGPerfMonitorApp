//
//  Combine+UIKit.swift
//  ChiefMT
//
//  Created by james_kong on 31/5/2022.
//

import Combine
import UIKit

protocol CombineCompatible {}

// MARK: - UIControl
extension UIControl {
    final class Subscription<SubscriberType: Subscriber, Control: UIControl>: Combine.Subscription where SubscriberType.Input == Control {
        private var subscriber: SubscriberType?
        private let input: Control

        init(subscriber: SubscriberType, input: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.input = input
            input.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(input)
        }
    }

    struct Publisher<Output: UIControl>: Combine.Publisher {
        typealias Output = Output
        typealias Failure = Never

        let output: Output
        let event: UIControl.Event

        init(output: Output, event: UIControl.Event) {
            self.output = output
            self.event = event
        }

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, input: output, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UIControl: CombineCompatible {}

extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControl.Publisher<UIControl> {
        .init(output: self, event: event)
    }
}

// MARK: - UIBarButtonItem
extension UIBarButtonItem {
    final class Subscription<SubscriberType: Subscriber, Input: UIBarButtonItem>: Combine.Subscription where SubscriberType.Input == Input {
        private var subscriber: SubscriberType?
        private let input: Input

        init(subscriber: SubscriberType, input: Input) {
            self.subscriber = subscriber
            self.input = input
            input.target = self
            input.action = #selector(eventHandler)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(input)
        }
    }

    struct Publisher<Output: UIBarButtonItem>: Combine.Publisher {
        typealias Output = Output
        typealias Failure = Never

        let output: Output

        init(output: Output) {
            self.output = output
        }

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, input: output)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UIBarButtonItem: CombineCompatible {
    convenience init(image: UIImage?, style: UIBarButtonItem.Style, cancellables: inout Set<AnyCancellable>, action: @escaping () -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }

    convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, cancellables: inout Set<AnyCancellable>, action: @escaping () -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }

    convenience init(title: String?, style: UIBarButtonItem.Style, cancellables: inout Set<AnyCancellable>, action: @escaping () -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }

    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, cancellables: inout Set<AnyCancellable>, action: @escaping () -> Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        self.publisher.sink { _ in action() }.store(in: &cancellables)
    }
}

extension CombineCompatible where Self: UIBarButtonItem {
    var publisher: UIBarButtonItem.Publisher<UIBarButtonItem> {
        .init(output: self)
    }
}
//Examples.swift
//import UIKit
//import Combine
//
//
//class ViewController: UIViewController {
//
//    var cancellables: Set<AnyCancellable> = []
//    let button1 = UIButton()
//    let button2 = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//                
//        // No good
//        let textField = UITextField()
//        textField.publisher(for: \.text)
//            .map { _ in (textField.text ?? "").count == 4 }
//            .assign(to: \.isEnabled, on: button1)
//            .store(in: &cancellables)
//
//        // OK
//        textField.publisher(for: .allEditingEvents)
//            .map { _ in (textField.text ?? "").count == 4 }
//            .assign(to: \.isEnabled, on: button1)
//            .store(in: &cancellables)
//
//        // OK
//        let completion: (Notification) -> Void = { _ in }
//
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in completion($0) }
//            .store(in: &cancellables)
//
//        // OK
//        button1.publisher(for: .touchUpInside)
//            .sink(receivedValue: {
//               // do something
//            })
//            .store(in: &cancellables)
//      
//        // OK
//        let buttonEvent: PassthroughSubject<UIControl, Never> = .init()
//        button1.publisher(for: .touchUpInside)
//            .subscribe(buttonEvent)
//            .store(in: &cancellables)
//
//        // OK
//        Publishers.Merge(button1.publisher(for: .touchUpInside), button2.publisher(for: .touchUpInside))
//            .subscribe(buttonEvent)
//            .store(in: &cancellables)
//
//    }
//}
