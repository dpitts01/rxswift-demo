//: [Previous](@previous)

import Foundation
import RxSwift
import RxRelay

// SUBJECTS
// Subject = Observable + Observer

/*
    1. PublishSubject - init empty, emits new; good for **events**
    2. BehaviorSubject - init default value, emits default or replays latest; good for **state**, settings
    3. ReplaySubject - init with buffer size n, maintains/replays buffer of last n elements
    4. AsyncSubject - emits last .next event when receives .completed (will not use)
 
    5. PublishRelay - wraps PublishSubject, can only accept + relay .next (no .completed, .error), infinite
    6. BehaviorRelay - wraps BehaviorSubject
*/

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    
    // acting as an observable
    // but we're not subscribed yet
    subject.on(.next("Is anyone listening?"))
    
    let subscription1 = subject
        .do(onDispose: {
            print("#1 disposed")
        })
        .subscribe(onNext: { string in
            print("sub1: " + string)
        })
    
    subject.on(.next("now we are subscribed"))
    subject.onNext("and another event")
    
    let subscription2 = subject
//        .subscribe(onNext: { string in
//            print("sub2: " + string)
//        })
        .subscribe { event in
            print("sub2:", event.element ?? event)
        }
    
    subject.onNext("and another event after #2 has joined us")
    
    subscription1.dispose()
    subject.onNext("and another event after #1 was disposed")
    
    subject.onCompleted()
    
    subject.onNext("after completed")
    subscription2.dispose()
    
    let disposeBag = DisposeBag()
    
    subject.subscribe {
        print("sub3:", $0.element ?? $0)
        // after completed, so no .next events, re-emits completed/error event
        // possible source of bugs, deal with in handler for stop events
    }
    .disposed(by: disposeBag)
    
    subject.onNext("?")
}

// MARK: BehaviorSubject

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}

example(of: "Behavior Subject") {
    let subject = BehaviorSubject(value: "Initial value")
    // If you can't provide an initial value, use an Optional<Element> or PublishSubject
    let disposeBag = DisposeBag()
    
    subject.onNext("1st value")
    
    subject
        .subscribe {
            print(label: "1:", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject.onError(MyError.anError)
    
    subject
        .subscribe {
            print(label: "2:", event: $0)
        }
        .disposed(by: disposeBag)
}

// MARK: ReplaySubject

example(of: "Replay Subject") {
    // buffers **in-memory**!! - be careful with memory use!
    // each element emitted is an **array** of buffer size, so don't make a replay subject of an array of Element??
    // not a substitute for caching (my note)
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject
        .subscribe {
        print(label: "1:", event: $0)
    }
    .disposed(by: disposeBag)
    
    subject
        .subscribe {
            print(label: "2:", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("4")
    subject.onError(MyError.anError)
    subject.dispose()
    // won't call dispose on it; it will be disposed/deallocated with ViewController is deallocated
    
    subject
        .subscribe {
            print(label: "3:", event: $0)
        }
        .disposed(by: disposeBag)
}

// MARK: Relay
// add new values to a relay with .accept NOT .on() or .onNext()

example(of: "PublishRelay") {
    let relay = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    relay.accept("Hello?")
    
    relay
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    relay
        .accept("I said, hello?")
    
}

example(of: "BehaviorRelay") {
    let relay = BehaviorRelay<String>(value: "Initial value")
    let disposeBag = DisposeBag()
    
    relay.accept("Replaced initial value")
    
    relay
        .subscribe {
            print(label: "1:", event: $0)
        }
        .disposed(by: disposeBag)
    
    relay.accept("1")
    
    relay
        .subscribe {
            print(label: "2:", event: $0)
        }
        .disposed(by: disposeBag)
    
    relay.accept("2")
    
    // can ask BehaviorRelay for current value at any time
    print("current value:", relay.value)
    
}

//: [Next](@next)
