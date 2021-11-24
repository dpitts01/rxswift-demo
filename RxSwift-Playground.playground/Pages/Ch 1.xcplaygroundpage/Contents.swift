//: [Previous](@previous)

import Foundation

var array = [1, 2, 3]
array.map {
    print($0)
    array = [4, 5, 6]
}
print(array)

/*
 MARK: Observables
 Observable<Element> emits, observer subscribes/receives
 Events: next, completed, error
 Infinite sequences (no completed) - e.g. UI changes; need default init value
 
 
 MARK: Operators
 
 
 MARK: Schedulers
 Equivalent to dispatch queues; coordinates your Rx with GCD queues
 SerialDispatchQueueScheduler
 ConcurrentDispatchQueueScheduler
 
 
 MARK: RxCocoa
 Reactive extensions for UI elements, e.g. observe the state of a toggle switch
 
 
 
 
 */

//: [Next](@next)
