//
//  LoggingMiddleware.swift
//  Example
//
//  Created by Miroslav Madjer on 18/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import RxStateFlow

struct LoggingMiddleware: Middleware {

    func before(event: Event, state: AppState) {
        switch event {
        case let event as UpdateCounter:
            print("About to update counter from \(state.counter) to \(event.value)")
        case CounterEvent.increase:
            print("About to increase counter")
        case CounterEvent.decrease:
            print("About to decrease counter")
        default:
            break
        }
    }

    func after(event: Event, state: AppState) {
        switch event {
        case _ as UpdateCounter:
            print("Counter updated to \(state.counter)")
        case CounterEvent.increase:
            print("Counter increased to \(state.counter)")
        case CounterEvent.decrease:
            print("Counter decreased to \(state.counter)")
        default:
            break
        }
    }
}
