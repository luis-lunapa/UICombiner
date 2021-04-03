//
//  UITextInputTests.swift
//  UICombinerTests
//
//  Created by Luis Gerardo Luna Pena on 03/04/21.
//

import Combine
@testable import UICombiner
import XCTest

class UITextInputTests: XCTestCase {

    var subscriptions = Set<AnyCancellable>()
    
    func testUITextField() {

        let textField = UITextField()
        let targetString = "Some written text"
        
        XCTAssertEqual(textField.text!, "")
        
        textField
            .publisher(for: UITextField.textDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { XCTAssertEqual($0.text!, targetString)}
            .store(in: &subscriptions)
        
        textField.text = targetString
        
    }
    
    func testUITextView() {
        let textView = UITextView()
        let targetText = "This is the input text for this view"
        
        textView
            .publisher(for: UITextView.textDidBeginEditingNotification)
            .receive(on: DispatchQueue.main)
            .sink { XCTAssertEqual($0.text, targetText)}
            .store(in: &subscriptions)
        
        textView.text = targetText
    }

}
