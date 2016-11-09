//
//  AppState.swift
//  Example
//
//  Created by Miroslav Madjer on 18/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import RxStateFlow

class AppState: StateObject {

    open fileprivate(set) dynamic var minCounterValue: Int = 0
    open fileprivate(set) dynamic var maxCounterValue: Int = 10
    open fileprivate(set) dynamic var counter: Int = 0

    override func react(to event: Event) {
        switch event {
        case let event as UpdateCounter:
            counter = event.value
        case CounterEvent.increase:
            counter += 1
        case CounterEvent.decrease:
            counter -= 1
        case CounterEvent.reset:
            counter = 0
        case HistoryEvent.undo:
            if let history = realm!.objects(History.self).first,
                let record = history.records.last {
                counter = record.state.counter
            }
        default:
            break
        }
    }
}
