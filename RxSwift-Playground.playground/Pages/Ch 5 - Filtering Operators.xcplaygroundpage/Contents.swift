//: [Previous](@previous)

import Foundation
import RxSwift

// MARK: ignoreElements
// Ignore all .next()  events, allow stop events only, .completed or .error

example(of: "ignoreElements") {
    let strikes = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    strikes
        .ignoreElements()
        .subscribe { _ in
            print("Completed?")
        }
        .disposed(by: disposeBag)
    
    strikes.onNext("Strike 1")
    strikes.onNext("Strike 2")
    strikes.onNext("Strike 3")
    strikes.onCompleted()
}

example(of: "elementAt") {
    let strikes = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    strikes
        .element(at: 2) // completes immediately after emitting element at [2]
        .subscribe(
            onNext: { _ in
                print("3rd strike")
            },
            onCompleted: { print("Out") }
        )
        .disposed(by: disposeBag)
    
    strikes.onNext("1")
    strikes.onNext("2")
    strikes.onNext("3")
}

example(of: "filter") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,3,4,5,6)
        .filter{ $0.isMultiple(of: 2) }
        .subscribe(
            onNext: {
                print($0)
            })
        .disposed(by: disposeBag)
}

example(of: "skip") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C", "D")
        .skip(1)
        .subscribe(
            onNext: {
                print($0)
            }
        )
        .disposed(by: disposeBag)
}

example(of: "skip(while:)") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,3,4,5,6,7,8,9,10)
        .skip(while: {  !$0.isMultiple(of: 5)} )
    // only skips until true ONCE, then emits all
    // meant for a sorted list???
        .subscribe(
            onNext: {
                print($0)
            }
        )
        .disposed(by: disposeBag)
}

example(of: "skip(until:)") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject
        .skip(until: trigger)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    subject.onNext("Waiting...")
    subject.onNext("Waiting...")
    trigger.onNext("Go!")
    subject.onNext("Going!")
    
}

example(of: "take") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,3,4,5,6)
        .take(5) //  take first 5 events emitted
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "take(while:)") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,3,4,5,6)
        .take(while: { $0 < 3 } )
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

// enumerated emits (index, element)
// would need $0, $1 or index, integer or similar

example(of: "take(while predicate:) + enumerated()") {
    let disposeBag = DisposeBag()
    
    Observable.of(2,2,4,4,5,6,6,8)
        .enumerated()
    // use take(while predicate:) here, otherwise ambiguous
    // takes until returns false
        .take(while: { (index, integer) in
            print("in: \(index), \(integer)")
            return integer.isMultiple(of: 2) && index < 3
        })
        .map(\.element) // ??
        .subscribe(onNext: {
            print("out: \($0)")
        })
        .disposed(by: disposeBag)
}

example(of: "take(until predicate:)") {
    let disposeBag = DisposeBag()
    
    Observable.of(1,2,3,4,5,6,6,7,14)
        .take(until: {
            $0.isMultiple(of: 3)
        }, behavior: .exclusive)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "take(until other:) w/ trigger") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    
    subject
        .take(until: trigger)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    subject.onNext("1")
    subject.onNext("2")
    trigger.onNext("Stop!")
    subject.onNext("3")
}

// example of takeUntil(self.rx.deallocated) for RxCocoa, archaiac

example(of: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    
    Observable.of("A", "A", "B", "B", "B", "C")
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

// can use Equatable-type closure with distinct until
example(of: "distinctUntilChanged(_ comparer:) w/ closure") {
    let disposeBag = DisposeBag()
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    Observable<NSNumber>.of(10,110,20,200,210,310)
        .distinctUntilChanged { a, b in
            guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                  let bWords = formatter.string(from: b)?.components(separatedBy: " ")
            else { return false }
            
            var containsMatch = false
            
            for aWord in aWords where bWords.contains(aWord) {
                containsMatch = true
                break
            }
            
            return containsMatch
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}


//: [Next](@next)
