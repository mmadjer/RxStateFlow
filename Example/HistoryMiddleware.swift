//
//  HistoryMiddleware.swift
//  Example
//
//  Created by Miroslav Valkovic-Madjer on 2/11/16.
//  Copyright © 2016 Miroslav Madjer. All rights reserved.
//

import RealmSwift
import RxStateFlow

/// The Serialization Error cases.
///
/// - unsupportedType:    If the `Event` is neither struct nor enum.
/// - unsupportedSubType: If the `Event` has unsupported poperty types.
public enum EventSerializationError: Error {
    // Only structs and enums are supported
    case unsupportedType
    // The provided type cannot be serialized
    case unsupportedSubType
}

public enum HistoryEvent: Event {
    case clear
    case undo
}

open class HistoryRecord: Object {
    private(set) dynamic var timestamp = Date()
    private(set) dynamic var type: String = ""
    private(set) dynamic var data: Data!
    private(set) dynamic var state: AppState!

    var raw: [String : Any]? {
        var raw: [String : Any]?

        do {
            raw = try PropertyListSerialization.propertyList(from: data,
                                                             options: [],
                                                             format: nil) as? [String : Any]
        } catch {}

        return raw
    }

    convenience init(event: Event, state: AppState) throws {
        self.init()

        let (type, data) = try serialize(event)

        self.type = type
        self.data = data
        self.state = state
    }

    ///  It converts an Event into an tuple of `type` and `data`.
    ///
    /// - Returns: The Event type and data
    /// - Throws: `SerializationError.UnsupportedType` if the `Event` is neither struct nor enum.
    /// `SerializationError.UnsupportedSubType` if the `Event` has unsupported poperty types.
    private func serialize(_ event: Event) throws -> (String, Data) {
        let mirror = Mirror(reflecting: event)

        guard mirror.displayStyle == .struct || mirror.displayStyle == .enum else {
            throw EventSerializationError.unsupportedType
        }

        var dictionary = [String : Any]()
        for case let (label?, anyValue) in mirror.children {
            dictionary[label] = anyValue
        }

        let valid = PropertyListSerialization.propertyList(dictionary, isValidFor: .binary)
        guard valid else {
            throw EventSerializationError.unsupportedSubType
        }

        let data = try PropertyListSerialization.data(fromPropertyList: dictionary,
                                                      format: .binary,
                                                      options: 0)

        var type = String(describing: mirror.subjectType)
        if mirror.displayStyle == .enum {
            type = "\(type).\(event.self)"
        }

        return (type, data)
    }
}

class History: Object {
    let records = List<HistoryRecord>()

    var hasRecords: Bool {
        return !records.isEmpty
    }

}

enum HistoryLimit {
    case none
    case limit(Int)
}

struct HistoryMiddleware: Middleware {

    let historyLimit: HistoryLimit

    init(limit: HistoryLimit = .none) {
        historyLimit = limit

        do {
            let realm = try Realm()
            if realm.objects(History.self).isEmpty {
                try realm.write {
                    realm.add(History())
                }
            }
        } catch _ { }
    }

    func before(event: Event, state: AppState) {
        switch event {
        // avoid endless recursion by checking if we've dispatched an error event
        case is ErrorEvent:
            break
        case HistoryEvent.clear:
            let history = state.realm!.objects(History.self).first!
            history.records.removeAll()
        case HistoryEvent.undo:
            break
        default:
            do {
                let history = state.realm!.objects(History.self).first!
                let copy = AppState(value: state)
                let record = try HistoryRecord(event: event, state: copy)

                history.records.append(record)

                switch historyLimit {
                    case .limit(let limit):
                        while history.records.count > limit {
                            history.records.remove(objectAtIndex: 0)
                        }
                    default:
                        break
                }
            } catch let error {
                print(error)
            }
        }
    }

    func after(event: Event, state: AppState) {
        switch event {
        case HistoryEvent.undo:
            let history = state.realm!.objects(History.self).first!
            history.records.removeLast()
        default:
            break
        }
    }

}
