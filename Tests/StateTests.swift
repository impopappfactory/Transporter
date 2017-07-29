//
//  StateTests.swift
//  Transporter
//
//  Created by Denys Telezhkin on 06.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import XCTest
import Transporter

class StateTests: XCTestCase {

    func testNumberEqualStates() {
        let state = TransporterState(6)
        let state2 = TransporterState(5+1)
        
        XCTAssert(state.value == state2.value)
    }
    
    func testNumberDifferentState() {
        let state = TransporterState(4)
        let state2 = TransporterState(3)
        
        XCTAssertFalse(state.value == state2.value)
    }

    func testDifferentStrings() {
        let state = TransporterState("Foo")
        let state2 = TransporterState("Bar")
        
        XCTAssertFalse(state.value == state2.value)
    }
    
    func testIdenticalStrings() {
        let state = TransporterState("omg")
        let state2 = TransporterState("omg")
        
        XCTAssert(state.value == state2.value)
    }
}
