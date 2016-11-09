//
//  Errors.swift
//  RxStateFlow
//
//  Created by Miroslav Valkovic-Madjer on 26/10/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

/// The default Error event.
///
/// - add: Event to add error to state.
/// - remove: Event to remove error from state.
public enum ErrorEvent: Event {
    case add(Error)
    case remove
}
