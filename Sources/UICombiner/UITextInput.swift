//
//  UITextField.swift
//  UICombiner
//
//  Created by Luis Gerardo Luna Pena on 13/10/20.
//

#if canImport(UIKit) && canImport(NotificationCenter)
import Foundation
import UIKit
import Combine
import NotificationCenter
import SwiftUI

extension UITextInput {
    
    /// Creates a `Publisher` for the given `Notification.Name`
    /// - Parameter name: The `Notification.Name` event to be published in the current element
    /// - Returns: `AnyPublisher` with empty `Output` to notified the event happened
    func publisher(for name: Notification.Name) -> AnyPublisher<Self, Never> {
        NotificationCenter
            .default
            .publisher(for: name, object: self)
            .compactMap { $0.object as? Self }
            .replaceError(with: self)
            .eraseToAnyPublisher()
    }
}
#endif
