//
//  EventTests.swift
//  Transporter
//
//  Created by Denys Telezhkin on 28.10.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//

import XCTest
import Transporter

func XCTAssertThrows<T: ErrorType where T: Equatable>(error: T, block: () throws -> ()) {
    do {
        try block()
    }
    catch let e as T {
        XCTAssertEqual(e, error)
    }
    catch {
        XCTFail("Wrong error")
    }
}

class NumberTests: XCTestCase {

    var machine: StateMachine<Int>!
    
    override func setUp() {
        super.setUp()
        let state = TransporterState(0)
        machine = StateMachine(initialState: state)
    }
    
    func testEventWithNoMatchingStates() {
        let event = TransporterEvent(name: "", sourceValues: [1,2], destinationValue: 3)
        XCTAssertThrows(EventError.NoSourceValue) {
            try self.machine.addEvent(event)
        }
    }
    
    func testEventWithNoSourceState() {
        machine.addState(TransporterState(2))
        
        let event = TransporterEvent(name: "", sourceValues: [], destinationValue: 2)
        
        XCTAssertThrows(EventError.NoSourceValue) {
            try self.machine.addEvent(event)
        }
    }
    
    func testFiringEvent() {
        let state = TransporterState(3)
        
        machine.addState(state)
        let event = TransporterEvent(name: "3", sourceValues: [0], destinationValue: 3)
        guard let _ = try? machine.addEvent(event) else {
            XCTFail()
            return
        }
        
        machine.fireEvent("3")
        XCTAssert(machine.isInState(3))
    }
    
    func testAddingEventWithWrongDestinationState() {
        let event = TransporterEvent(name: "3", sourceValues: [0], destinationValue: 2)
        XCTAssertThrows(EventError.NoDestinationValue) {
            try self.machine.addEvent(event)
        }
    }
}

class StringTests: XCTestCase {
    
    var machine: StateMachine<String>!
    
    override func setUp() {
        super.setUp()
        let state = TransporterState("Initial")
        let passedState = TransporterState("Passed")
        machine = StateMachine(initialState: state)
        machine.addState(passedState)
    }
    
    func testCanFireEvent() {
        let event = TransporterEvent(name: "Pass", sourceValues: ["Initial"], destinationValue: "Passed")
        
        XCTAssertFalse(machine.canFireEvent("Pass"))
        XCTAssertFalse(machine.canFireEvent(event))
        _ = try? machine.addEvent(event)
        XCTAssertTrue(machine.canFireEvent("Pass"))
        XCTAssertTrue(machine.canFireEvent(event))
        
        machine.fireEvent("Pass")
        XCTAssert(machine.isInState("Passed"))
    }
    
    func testShouldFireEventBlock() {
        let event = TransporterEvent(name: "Pass", sourceValues: ["Initial"], destinationValue: "Passed")
        event.shouldFireEvent = { _ in
            return false
        }
        _ = try? machine.addEvent(event)
        
        let transition = machine.fireEvent("Pass")
        
        switch transition {
        case .Success(_,_):
            XCTFail("success should not be fired")
        case .Error(let error):
            XCTAssertEqual(error, TransitionError.TransitionDeclined)
        }
    }
    
    func testSourceStateUnavailable() {
        let state = TransporterState("Completed")
        let event = TransporterEvent(name: "Completed", sourceValues: ["Passed"], destinationValue: "Completed")
        machine.addState(state)
        _ = try? machine.addEvent(event)
        
        let transition = machine.fireEvent("Completed")
        
        switch transition {
        case .Success(_,_):
            XCTFail("success should not be fired")
        case .Error(let error):
            XCTAssertEqual(error, TransitionError.WrongSourceState)
        }
    }
    
    func testStatePassed() {
        let event = TransporterEvent(name: "Pass", sourceValues: ["Initial"], destinationValue: "Passed")
        _ = try? machine.addEvent(event)
        
        let transition = machine.fireEvent("Pass")
        switch transition {
        case .Success(let sourceState,let destinationState):
            XCTAssert(sourceState.value == "Initial")
            XCTAssert(destinationState.value == "Passed")
        case .Error(_):
            XCTFail("There shouldn't be any errors")
        }
    }
    
    func testTransitionSuccessful()
    {
        let event = TransporterEvent(name: "Pass", sourceValues: ["Initial"],destinationValue: "Passed")
        _ = try? machine.addEvent(event)
        let transition = machine.fireEvent("Pass")
        
        XCTAssert(transition.successful)
    }
    
    func testTransitionFailed()
    {
        let event = TransporterEvent(name: "Pass", sourceValues: ["Initial"],destinationValue: "Passed")
        _ = try? machine.addEvent(event)
        let transition = machine.fireEvent("Foo")
        
        XCTAssertFalse(transition.successful)
    }
    
    func testUnknownEvent() {
        let transition = machine.fireEvent("Foo")
        
        switch transition {
        case .Success(_, _):
            XCTFail("Event does not exist and should not be fired")
        case .Error(let error):
            XCTAssertEqual(error, TransitionError.UnknownEvent)
        }
    }
    
    func testWillFireEventBlock() {
        let event = TransporterEvent(name: "Pass", sourceValues: ["Initial"], destinationValue: "Passed")
        var foo = 5
        event.willFireEvent = { _ in
            XCTAssert(self.machine.isInState("Initial"))
            foo = 7
        }
        _ = try? machine.addEvent(event)
        
        _ = machine.fireEvent("Pass")
        XCTAssert(foo == 7)
    }
    
    func testDidFireEventBlock() {
        let event = TransporterEvent(name: "Pass", sourceValues: ["Initial"], destinationValue: "Passed")
        var foo = 5
        event.didFireEvent = { _ in
            XCTAssert(self.machine.isInState("Passed"))
            foo = 7
        }
        _ = try? machine.addEvent(event)
        
        _ = machine.fireEvent("Pass")
        XCTAssert(foo == 7)
    }
}