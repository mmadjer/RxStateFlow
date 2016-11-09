//
//  Command.swift
//  Example
//
//  Created by Miro Valkovic-madjer on 20/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import RxStateFlow

struct IncreaseCounter: Command {
    func execute(state: AppState, store: Store<AppState>) {
        if state.counter < state.maxCounterValue {
            store.dispatch(event: CounterEvent.increase)
        } else {
            store.dispatch(event: ErrorEvent.add(CounterError.maxReached))
        }
    }
}

struct DecreaseCounter: Command {
    func execute(state: AppState, store: Store<AppState>) {
        if state.counter > state.minCounterValue {
            store.dispatch(event: CounterEvent.decrease)
        } else {
            store.dispatch(event: ErrorEvent.add(CounterError.minReached))
        }
    }
}
