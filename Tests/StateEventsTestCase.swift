//
//  StateEventsTestCase.swift
//  Transporter
//
//  Created by Denys Telezhkin on 15.10.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import XCTest
import Transporter

class StateEventsTestCase: XCTestCase {

    let initial = TransporterState(4)
    var machine : StateMachine<Int>!
    
    override func setUp() {
        super.setUp()
        
        machine = StateMachine(initialState: initial)
    }

    func testWillEnterBlock() {
        let state = TransporterState(5)
        var x = 5
        state.willEnterState = { _ in
            x = 6
        }
        
        machine.addState(state)
        machine.activateState(5)
        
        XCTAssert(x==6)
    }
    
    func testDidEnterBlock() {
        let state = TransporterState(3)
        var x = 1
        state.didEnterState = { _ in x=2 }
        
        machine.addState(state)
        machine.activateState(3)
        
        XCTAssert(x==2)
    }

}
