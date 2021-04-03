//
//  UIControlTests.swift
//  UICombinerTests
//
//  Created by Luis Gerardo Luna Pena on 03/04/21.
//

import Combine
@testable import UICombiner
import XCTest

class UIControlTests: XCTestCase {
    
    var subscriptions = Set<AnyCancellable>()
    func testUISwitch() {
        
        let mySwitch = UISwitch()
        
        mySwitch
            .publisher(for: .valueChanged)
            .receive(on: DispatchQueue.main)
            .sink { XCTAssertFalse(mySwitch.isOn) }
            .store(in: &subscriptions)
    }
}
