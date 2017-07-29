//
//  State.swift
//  Transporter
//
//  Created by Denys Telezhkin on 06.07.14.
//  Copyright (c) 2014 Denys Telezhkin. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/**
    `State` class encapsulates state with some value, and closure-based callbacks to fire when state machine enters or exits state.
*/
public class TransporterState <T: Hashable>  {
    
    /// Value of state
    public let value : T
    
    /// Closure, that will be executed, before state machine enters this state
    public var willEnterState: ( (enteringState : TransporterState<T> ) -> Void)?
    
    /// Closure, that will be executed, after state machine enters this state
    public var didEnterState:  ( (enteringState : TransporterState<T> ) -> Void)?
    
    /// Closure, that will be executed before state machine will switch from current state to another state.
    public var willExitState:  ( (exitingState  : TransporterState<T> ) -> Void)?
    
    /// Closure, that will be executed after state machine switched from current state to another state.
    public var didExitState:   ( (exitingState  : TransporterState<T> ) -> Void)?
    
    /// Create state with value
    /// - Parameter value: value of state
    public init(_ value: T) {
        self.value = value
    }
}
