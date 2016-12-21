//
//  TestMocks.swift
//  RxStateFlow
//
//  Created by Miroslav Valkovic-Madjer on 27/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

@testable import RxStateFlow

class TestState: StateObject {

    open fileprivate(set) dynamic var value: String = ""

    override func react(to event: Event) {
        switch event {
        case let event as TestStringEvent:
            value = event.value
        default:
            break
        }
    }
}

struct TestStringEvent: Event {
    let value: String
}

struct TestCommand: Command {
    typealias StateType = TestState

    func execute(state: StateType, store: Store<StateType>) {
        store.dispatch(event: TestStringEvent(value: "OK"))
    }
}

struct TestConditionalCommand: Command {
    typealias StateType = TestState

    func execute(state: StateType, store: Store<StateType>) {
        if state.value == "INIT" {
            store.dispatch(event: TestStringEvent(value: "OK"))
        } else {
            store.dispatch(event: TestStringEvent(value: "NOT OK"))
        }
    }
}

struct TestAsyncCommand: Command {
    typealias StateType = TestState

    func execute(state: StateType, store: Store<StateType>) {
        DispatchQueue.global(qos: .default).async {
            store.dispatch(event: TestStringEvent(value: "OK"))
        }
    }
}
