//
//  State.swift
//  RxStateFlow
//
//  Created by Miroslav Madjer on 18/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import RealmSwift

/// Defines the interface of States in RxStateFlow.
/// `StateObject` is the default implementation of this interface.
public protocol State {

    /// React to incoming events which updates the state.
    /// - remark: In the world of Redux, this is the Reducer.
    ///
    /// - parameter event: The event that is being dispatched to the store.
    func react(to event: Event)
}

/// This class is the default implementation of the `State` protocol.
open class StateObject: Object, State {

    open func react(to event: Event) { }
}
