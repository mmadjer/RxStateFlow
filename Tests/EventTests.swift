//
//  EventTests.swift
//  RxStateFlow
//
//  Created by Miroslav Valkovic-Madjer on 27/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import XCTest
@testable import RxStateFlow

class EventTests: TestCaseBase {

    var store: Store<TestState>!

    override func setUp() {
        super.setUp()

        store = Store<TestState>()
        store.dispatch(event: TestStringEvent(value: ""))
    }

    func testDispatchEvent() {
        let event = TestStringEvent(value: "OK")

        store.dispatch(event: event)

        XCTAssertEqual(store.state.value.value, "OK")
    }

    func testDispatchEventPerformance() {
        self.measure {
            let event = TestStringEvent(value: "OK")
            self.store.dispatch(event: event)
            XCTAssertEqual(self.store.state.value.value, "OK")
        }
    }
}
