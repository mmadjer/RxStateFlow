//
//  Event.swift
//  Example
//
//  Created by Miroslav Madjer on 18/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import RxStateFlow

// MARK: - Events

struct UpdateCounter: Event {
    let value: Int
}

enum CounterEvent: Event {
    case increase
    case decrease
    case reset
}
