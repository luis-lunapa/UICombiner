//
//  UIPickerView.swift
//  UICombiner
//
//  Created by Luis Gerardo Luna Pena on 03/04/21.
//

#if canImport(UIKit) && canImport(NotificationCenter)
import Combine
import Foundation
import NotificationCenter
import UIKit

extension UIPickerView {
    
    func delegatePublisher(items: [String]) -> Publishers.UIPickerViewPublisher {
        return Publishers.UIPickerViewPublisher(self, items: items)
    }
    
    enum Events {
        case didSelectRow(_ row: Int, component: Int)
        case titleForRow(_ row: Int, component: Int)
        
    }
}

extension Publishers {
    struct UIPickerViewPublisher: Publisher {
        typealias Output = UIPickerView.Events
        
        typealias Failure = Never

        private let picker: UIPickerView
        
        public var items: [String]
        
        init(_ picker: UIPickerView,
             items: [String] = []) {
            self.picker = picker
            self.items = items
        }
        
        func receive<S>(subscriber: S) where S : Subscriber,
                                             Self.Failure == S.Failure,
                                             Self.Output == S.Input {
            
            let subscription = UIPickerViewSubscription(subscriber: subscriber,
                                                        picker: picker,
                                                        items: items)
            
            subscriber.receive(subscription: subscription)
        }
        
        
    }
    
    class UIPickerViewSubscription<S: Subscriber>: Subscription where S.Input == UIPickerView.Events,
                                                                      S.Failure == Never {
        
        private var subscriber: S?
        
        private weak var picker: UIPickerView?
        
        var delegate: Coordinator?
        
        var pickerItems: [String]
        
        init(subscriber: S, picker: UIPickerView, items: [String]) {
            self.subscriber = subscriber
            self.picker = picker
            self.pickerItems = items
            makeSubscription()
        }
        
        private func makeSubscription() {
            self.delegate = Coordinator(self)
            picker?.delegate = delegate
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            picker = nil
            delegate = nil
        }
    
        class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
            
            weak var parent: UIPickerViewSubscription?
            
            init(_ parent: UIPickerViewSubscription) {
                self.parent = parent
            }
            
            func pickerView(_ pickerView: UIPickerView,
                            didSelectRow row: Int,
                            inComponent component: Int) {
                
                _ = parent?.subscriber?.receive(.didSelectRow(row, component: component))
            }
            
            func pickerView(_ pickerView: UIPickerView,
                            titleForRow row: Int,
                            forComponent component: Int) -> String? {
                return parent?.pickerItems[row]
            }
            
            func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                parent?.pickerItems.count ?? 0
            }
            
            func numberOfComponents(in pickerView: UIPickerView) -> Int {
                1
            }
        }
    }
}
#endif
