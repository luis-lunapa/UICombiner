//
//  XCTest+Extension.swift
//  UICombiner
//
//  Created by Luis Gerardo Luna Pena on 03/04/21.
//

import XCTest

extension XCTestCase {
    
    /// Checks every 0.01 seconds if a condition is fulfilled before its timeout
    func expectToEventually(_ isFulfilled: @autoclosure () -> Bool,
                            timeout: TimeInterval,
                            message: String = "",
                            file: StaticString = #filePath,
                            line: UInt = #line) {
        func wait() { RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01)) }
        
        let timeout = Date(timeIntervalSinceNow: timeout)
        func isTimeout() -> Bool { Date() >= timeout }
        
        repeat {
            if isFulfilled() { return }
            wait()
        } while !isTimeout()
        
        XCTFail(message, file: file, line: line)
    }
}
