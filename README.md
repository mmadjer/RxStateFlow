# RxStateFlow

<!-- [![Build Status](https://travis-ci.org/mmadjer/RxStateFlow.svg?branch=master)](https://travis-ci.org/mmadjer/RxStateFlow) -->
[![Platform support](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://github.com/mmadjer/RxStateFlow/blob/master/LICENSE)
[![Swift 3 compatible](https://img.shields.io/badge/swift3-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/RxStateFlow.svg?style=flat)](https://cocoapods.org/pods/RxStateFlow)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/mmadjer/RxStateFlow/blob/master/LICENSE)

## Introduction

An implementation of a Persistent Reactive Unidirectional Date Flow using [Realm](https://realm.io/) and [RxSwift](https://github.com/ReactiveX/RxSwift).
RxStateFlow provides an architecture where the core idea is that your code is built around a `Model` of your application state, a way to `update` your model, and a way to `view` your model.

Using RxStateFlow makes it very easy to have the app state  persist (between app launches), reactive and accessible across classes and threads.

## Architecture

### State
Since the framework uses Realm a `State` is anything that conforms to `StateObject` which actually is a [Realm Model](https://realm.io/docs/swift/latest/#models) sub-class - this way the application state always persist between app launches and can be observed on any thread.

```swift
class AppState: StateObject {
    fileprivate(set) dynamic var counter: Int = 0

    override func react(to event: Event) {
        switch event {
        case CounterEvent.increase:
            counter += 1
        default:
            break
        }
    }
}
```

Use composition to create state for more complicated cases than this. Parent states can react to events however they wish, although this will in most cases involve delegating to substates default behavior.

```swift
class AnotherObject: StateObject {
    fileprivate(set) dynamic var value: String = ""

    override func react(to event: Event) {
    }
}

class AppState: StateObject {
    fileprivate(set) dynamic var counter: Int = 0
    fileprivate(set) dynamic var another: AnotherObject

    override func react(to event: Event) {
        another.react(to: event)
    }
}
```

### State Changes
RxStateFlow allows only state changes through events. Events are small pieces of data which describe a state change and don't contain any code. They are consumed by the store and forwarded to method `react(to event: Event)` on the root state. This method will handle the events by implementing a different state change for each event.

#### Event
Can trigger a state update. Events can be defined as struct or enums. Here are some examples:

The simplest form.
```swift
struct UpdateCounter: Event { }
```
As enums.
```swift
enum CounterEvent: Event {
    case increase
    case decrease
    case reset
}
```
Pass some data along with the event.
```swift
struct UpdateCounter: Event {
    let value: Int
}
```
Generics work as well.
```swift
struct Update<T>: Event {
    var value: T
}
```

#### Command
Command helps you to interact with the Store in a safe and consistent way where you need events to be dispatched to a store at a later point. Useful for networking, working with databases, or any other asynchronous operation.

In addition, it can be used to perform a conditional dispatch instead of checking the necessary state directly in the view or view controller, which avoids any sort of complicated business logic in the view.

```swift
struct IncreaseCounter: Command {
    func execute(state: AppState, store: Store<AppState>) {
        if state.counter < 10 {
            store.dispatch(event: CounterEvent.increase)
        }
    }
}

// to dispatch a command
store.dispatch(command: IncreaseCounter())
```

### Store
Holds the application state and responsible for dispatching events and commands. Received events will in turn update the state by calling `react(to event: Event)` on the root state. Whenever the state in the store changes, the store will notify all observers.

Create a shared global Store used by your entire application.

```swift
let store = Store<AppState>()
```

**NOTE:** DO NOT produce side effects, make async calls, or use impure functions like NSDate() in `react(to event: Event)`.

### Views
In a RxStateFlow app your views update when your state changes. Your views become simple visualizations of the current app state.

By subscribing to the state, we ensure that whenever this view controller is visible it is up to date with the latest application state. Upon initial subscription, the store will send the latest state to the subscriber's update function.

```swift
class ViewController: UIViewController {
    internal var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Subscribe to store changes
        store.state.asDriver().drive(onNext: { state in
            // update UI
            }).addDisposableTo(bag)
    }
}
```

### Middleware
Middleware is great to perform tasks around an event. Each middleware gets called every time an event is passed in, before and after application state update. Middleware is not allowed to mutate the state, but it gets a copy of the state along with the event. Useful for logging, analytics, error handling, and other side effects.

```swift
struct LoggingMiddleware: Middleware {

    func before(event: Event, state: AppState) {
        switch event {
        case CounterEvent.increase:
            print("About to increase counter")
        default:
            break
        }
    }

    func after(event: Event, state: AppState) {
        switch event {
        case CounterEvent.increase:
            print("Counter increased")
        default:
            break
        }
    }
}
```

## Requirements

* iOS 10.0+
* Xcode 8.1+
* Swift 3

## Examples

Follow these 3 steps to run Example project: Clone RxStateFlow repository, open RxStateFlow workspace and run the *Example* project.

The Example project consist of:
* Events
* Commands (Conditional dispatch)
* History middleware
* Logging middleware
* Error handling

## Installation

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install RxStateFlow, simply add the following line to your Podfile:

```ruby
pod 'RxStateFlow'
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

To install RxStateFlow, simply add the following line to your Cartfile:

```ogdl
github "mmadjer/RxStateFlow"
```

# Credits

- Thanks a lot to [Marin Todorov](http://rx-marin.com/post/rxswift-realm-reactive-app-settings/) from where the idea originated.
- Also to [Jason Larsen](https://github.com/jarsen/Reactor) - some implementation details were provided by his library.
