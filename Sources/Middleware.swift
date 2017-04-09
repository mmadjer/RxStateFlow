//
//  Middleware.swift
//  RxStateFlow
//
//  Created by Miroslav Madjer on 18/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

public protocol AnyMiddleware {

    /// Called before the dispatched Event is processed.
    ///
    /// - parameter event: The event that is being dispatched to the store.
    /// - parameter state: The current state.
    func before(event: Event, state: Any)

    /// Called after the dispatched Event has been processed.
    ///
    /// - parameter event: The event that is being dispatched to the store.
    /// - parameter state: The current state.
    func after(event: Event, state: Any)
}

/// Defines the interface of Middlewares in RxStateFlow.
///
/// - remark: Each middleware gets called every time an Event is passed in.
/// Middleware is not allowed to mutate the State, but it does get a copy of the State
/// along with the Event. Middleware makes it easy to add things like logging, analytics,
/// and error handling to an application.
public protocol Middleware: AnyMiddleware {
    associatedtype StateType

    func before(event: Event, state: StateType)
    func after(event: Event, state: StateType)
}

public extension Middleware {

    func before(event: Event, state: Any) {
        if let state = state as? StateType {
            before(event: event, state: state)
        }
    }

    func after(event: Event, state: Any) {
        if let state = state as? StateType {
            after(event: event, state: state)
        }
    }
}

public struct Middlewares<State: StateObject> {

    private(set) var middleware: AnyMiddleware
}
