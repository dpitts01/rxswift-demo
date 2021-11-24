//: [Previous](@previous)

import Foundation
import RxSwift

// SUBJECTS
// Subject = Observable + Observer

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    
    // acting as an observable
    // but we're not subscribed yet
    subject.on(.next("Is anyone listening?"))
    
    let subscription1 = subject
        .subscribe(onNext: { string in
            print(string)
        })
    
    subject.on(.next("now we are subscribed"))
    subject.onNext("and another event")
}




//: [Next](@next)
