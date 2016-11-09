//
//  StoreTests.swift
//  RxStateFlow
//
//  Created by Miroslav Valkovic-Madjer on 27/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import XCTest
import RealmSwift
@testable import RxStateFlow

class StoreTests: TestCaseBase {

    func testStoreInit() {
        let store = Store<TestState>()

        XCTAssertNotNil(store.state)

        do {
            let realm = try Realm()
            let state = realm.objects(TestState.self).first!
            XCTAssertNotNil(state)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

}
