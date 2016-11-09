//
//  TestCaseBase.swift
//  RxStateFlow
//
//  Created by Miroslav Valkovic-Madjer on 2/11/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import XCTest
import RealmSwift

class TestCaseBase: XCTestCase {
    override func setUp() {
        super.setUp()

        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name!
    }
}
