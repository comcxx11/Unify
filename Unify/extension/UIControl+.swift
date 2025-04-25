//
//  UIControl+.swift
//  Unify
//
//  Created by Seojin on 4/25/25.
//

import UIKit
import Combine

extension UIControl {
    
    struct InteractionPublisher: Publisher {
        typealias Output = Void
        typealias Failure = Never

        private let control: UIControl
        private let event: UIControl.Event

        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }

        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = InteractionSubscription(subscriber: subscriber, control: control, event: event)
            subscriber.receive(subscription: subscription)
        }

        private final class InteractionSubscription<S: Subscriber>: Subscription where S.Input == Void {
            private var subscriber: S?
            private weak var control: UIControl?
            private let event: UIControl.Event

            init(subscriber: S, control: UIControl, event: UIControl.Event) {
                self.subscriber = subscriber
                self.control = control
                self.event = event

                control.addTarget(self, action: #selector(eventHandler), for: event)
            }

            func request(_ demand: Subscribers.Demand) {
                // do nothing
            }

            func cancel() {
                control?.removeTarget(self, action: #selector(eventHandler), for: event)
                subscriber = nil
            }

            @objc private func eventHandler() {
                _ = subscriber?.receive(())
            }
        }
    }
    
    func publisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        return InteractionPublisher(control: self, event: event).eraseToAnyPublisher()
    }
    
    func bindTap(to action: @escaping () -> Void) -> AnyCancellable {
        publisher(for: .touchUpInside)
            .sink(receiveValue: { action() })
    }
    
    func bindTap<Event>(to subject: PassthroughSubject<Event, Never>, event: Event) -> AnyCancellable {
        publisher(for: .touchUpInside)
            .sink(receiveValue: { subject.send(event) })
    }
    
}
