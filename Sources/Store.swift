//
//  Store.swift
//  RxStateFlow
//
//  Created by Miroslav Madjer on 18/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import RealmSwift
import RxSwift

/// This class is the default `Store` implementation.
/// Applications have a single store that stores the entire application state.
/// Stores receive events to calculate state changes. Upon every state update a store
/// informs all of its observers.
open class Store<State: StateObject> {

    private var stateNotification: NotificationToken?

    fileprivate var middlewares = [Middlewares<State>]()

    /// The current state stored in the store.
    public let state: Variable<State>

    /// The current errors.
    public let errors = Variable<Error?>(nil)

    // MARK: - Initialization

    /// Initializes the store.
    ///
    /// - parameter middlewares: A list of middleware.
    /// Middleware is applied in the order in which it is passed into this constructor.
    ///
    /// - returns: A newly created Store.
    public init(middlewares: [AnyMiddleware] = []) {
        self.middlewares = middlewares.map(Middlewares.init)

        //swiftlint:disable force_try
        let realm = try! Realm()
        //swiftlint:enable force_try

        // Fetch all objects of class `State` stored in Realm and any time those are updated
        // call the closure provided to addNotificationBlock.
        // The closure uses the first result (the only `State` object in the Realm actually)
        // and emit it as a .Next event from the state subject.
        let stateObjects = realm.objects(State.self)

        // Check whether there’s an State object already stored in Realm and if not - create one
        if stateObjects.isEmpty {
            do {
                state = Variable(State())

                try realm.write {
                    realm.add(state.value)
                }
            } catch _ {
                // TODO: What's the best why to handle this case?
                // Returning nil or throwing error,
                // but both won't work if store is used as a global variable.
            }
        } else {
            state = Variable(stateObjects.first!)
        }

        stateNotification = realm.addNotificationBlock { [weak self] (_, realm) in
            self?.state.value = realm.objects(State.self).first!
        }
    }

    deinit {
        stateNotification?.stop()
    }

}

// MARK: - Event Dispatching

extension Store {

    /// Dispatches an event. This is the simplest way to modify the stores state.
    ///
    /// Example of dispatching an event:
    /// ```
    /// store.dispatch( CounterAction.IncreaseCounter )
    /// ```
    ///
    /// - parameter event: The event that is being dispatched to the store.
    public func dispatch(event: Event) {
        handleError(event)

        updateState { state in
            middlewares.forEach { $0.middleware.before(event: event, state: state) }
            state.react(to: event)
            middlewares.reversed().forEach { $0.middleware.after(event: event, state: state) }
        }
    }

    /// Dispatches a command. This is the simplest way to dispatch an Event at a later point,
    /// after a network request, database query, or other asynchronous operation.
    ///
    /// Example of dispatching a command:
    /// ```
    /// store.dispatch(command: CreateItem(item: newItem))
    /// ```
    ///
    /// - parameter command: The command to execute.
    public func dispatch<C: Command>(command: C) where C.StateType == State {
        command.execute(state: state.value, store: self)
    }

    /// Updates the app state.
    ///
    /// - remark: It takes a closure inside which you can update the app state.
    /// This pattern creates a Realm on the current thread, fetches the current app state
    /// and injects it to the user-defined updates closure.
    /// All wrapped in a `Realm.write` call so that it is actually allowed to update
    /// the state object from inside the closure.
    ///
    /// - parameter state: A closure inside which you can update the app state.
    private func updateState(_ state: (inout State) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                var currentState = realm.objects(State.self).first!
                state(&currentState)
            }
        } catch let error {
            dispatch(event: ErrorEvent.add(error))
        }
    }

    private func handleError(_ event: Event) {
        switch event {
        case ErrorEvent.add(let error):
            errors.value = error
        case ErrorEvent.remove:
            errors.value = nil
        default:
            break
        }
    }
}
