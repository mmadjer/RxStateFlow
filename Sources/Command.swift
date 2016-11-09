//
//  Command.swift
//  RxStateFlow
//
//  Created by Miro Valkovic-madjer on 20/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

/// Defines the interface of Commands in RxStateFlow.
///
/// All events that want to be able to be dispatched to a store at a later point
/// need to conform to this protocol. For example, after a network request, database query,
/// or other asynchronous operation.
///
/// In addition, it can be used to perform a conditional dispatch instead of checking
/// the necessary state directly in the view or view controller, which avoids any sort of
/// complicated business logic in the view.
///
/// In these cases, Command helps you interact with the Store in a safe and consistent way.
/// Command gets a copy of the current state, and a reference to the Store
/// which allows them to dispatch Events as necessary.
public protocol Command {
    associatedtype StateType: StateObject

    ///
    ///
    /// - parameter state: The current state.
    /// - parameter store: A reference to the store.
    func execute(state: StateType, store: Store<StateType>)
}
