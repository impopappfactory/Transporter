//
//  EnumTestCase.swift
//  Transporter
//
//  Created by Denys Telezhkin on 13.11.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import XCTest
import Transporter

enum StateEnum {
    case Start
    case Progress
    case Finish
}

struct EnumEvents {
    static let MakeProgress = "MakeProgress"
    static let RaceToFinish = "RaceToFinish"
}

class EnumTestCase: XCTestCase {

    var machine : StateMachine<StateEnum>!
    
    override func setUp() {
        super.setUp()
        
        let initialState = TransporterState(StateEnum.Start)
        machine = StateMachine(initialState: initialState)
        
        let progressState = TransporterState(StateEnum.Progress)
        let finishState = TransporterState(StateEnum.Finish)
        
        machine.addStates([progressState,finishState])
    }
    
    func testStateChange() {
        let state = machine.stateWithValue(.Progress)
        
        var x = 0
        state?.didEnterState = { _ in x = 6 }
        
        machine.activateState(.Progress)
        
        XCTAssertEqual(x, 6)
    }
    
    func testFiringEvent() {
        let event = TransporterEvent(name: EnumEvents.MakeProgress, sourceValues: [StateEnum.Start], destinationValue: StateEnum.Progress)
        
        _ = try? machine.addEvent(event)
        machine.fireEvent(EnumEvents.MakeProgress)
        
        XCTAssert(machine.isInState(.Progress))
    }
}
