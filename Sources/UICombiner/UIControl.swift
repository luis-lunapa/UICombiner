//
//  UIControl.swift
//  UICombiner
//
//  Created by Luis Gerardo Luna Pena on 12/10/20.
//

#if canImport(UIKit)
import Foundation
import UIKit
import Combine

public extension UIControl {
    
    /// Publisher that emits events of the given kind
    /// - Parameter event: The `UIControl.Event` to publish changes of
    /// - Returns: `AnyPublisher` with empty `Output` to notified the event happened
    func publisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        Publishers
            .UIControlPublisher(control: self,
                                event: event)
            .eraseToAnyPublisher()
    }
}

extension Publishers {
    
    /// Pubisher for `UIControl` events
    /// internally wraps a selector and notifies the subscribers
    /// some desired event did occur in the observed element
    struct UIControlPublisher: Publisher {
        
        typealias Output = Void
        
        typealias Failure = Never
        
        private let control: UIControl
        
        private let event: UIControl.Event
        
        init(control: UIControl,
             event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber,
                                             Self.Failure == S.Failure,
                                             Self.Output == S.Input {
            
            let subscription = Subscriptions.UIControlSubscription(subscriber)
            
            subscriber.receive(subscription: subscription)
            
            control.addTarget(self, action: #selector(subscription.handle(_:)), for: event)
            
        }
    }
}

extension Subscriptions {
    
    class UIControlSubscription<S: Subscriber>: Subscription where S.Input == Void,
                                                                    S.Failure == Never {
        
        private var subscriber: S?
      
        init(_ subscriber: S) {
            self.subscriber = subscriber
        }
        
        @objc
        func handle(_ event: UIControl.Event) {
            _ = subscriber?.receive(())
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
        }

    }
}
#endif
