//
//  CommandTests.swift
//  RxStateFlow
//
//  Created by Miroslav Valkovic-Madjer on 27/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import RxStateFlow

class CommandTests: TestCaseBase {

    var store: Store<TestState>!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        store = Store<TestState>()

        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        disposeBag = nil
    }

    /**
     it can dispatch events
     */
    func testCanDispatch() {
        store.dispatch(command: TestCommand())

        XCTAssertEqual(store.state.value.value, "OK")
    }

    func testCanDispatchPerformance() {
        self.measure {
            self.testCanDispatch()
        }
    }

    /**
     it can dispatch events asynchronously
     */
    func testCanDispatchAsync() {
        let asyncExpectation = expectation(description: "It can dispatch events asynchronously")

        store.state.asObservable().subscribe(onNext: { state in
            if self.store.state.value.value != "" {
                XCTAssertEqual(self.store.state.value.value, "OK")
                asyncExpectation.fulfill()
            }
        }).addDisposableTo(disposeBag)

        store.dispatch(command: TestAsyncCommand())

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectations errored: \(error)")
            }
        }
    }

    func testCanDispatchAsyncPerformance() {
        self.measure {
            self.testCanDispatchAsync()
        }
    }

    func testConditionalDispatch() {
        store.dispatch(event: TestStringEvent(value: "INIT"))
        store.dispatch(command: TestConditionalCommand())

        XCTAssertEqual(store.state.value.value, "OK")
    }

    func testFailConditionalDispatch() {
        store.dispatch(command: TestConditionalCommand())

        XCTAssertEqual(store.state.value.value, "NOT OK")
    }

}
