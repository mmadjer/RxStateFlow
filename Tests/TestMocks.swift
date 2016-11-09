//
//  TestMocks.swift
//  RxStateFlow
//
//  Created by Miroslav Valkovic-Madjer on 27/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

@testable import RxStateFlow

class TestState: StateObject {

    public private(set) dynamic var value: String = ""

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
    func execute(state: TestState, store: Store<TestState>) {
        store.dispatch(event: TestStringEvent(value: "OK"))
    }
}

struct TestConditionalCommand: Command {
    func execute(state: TestState, store: Store<TestState>) {
        if state.value == "INIT" {
            store.dispatch(event: TestStringEvent(value: "OK"))
        } else {
            store.dispatch(event: TestStringEvent(value: "NOT OK"))
        }
    }
}

struct TestAsyncCommand: Command {
    func execute(state: TestState, store: Store<TestState>) {
        DispatchQueue.global(qos: .default).async {
            store.dispatch(event: TestStringEvent(value: "OK"))
        }
    }
}
