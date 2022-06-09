//: [Previous](@previous)

import Combine
import Dispatch
import Foundation

public struct Effect<A> {
  public let run: (@escaping (A) -> Void) -> Void
  
  public func map<B>(_ f: @escaping (A) -> B) -> Effect<B> {
    return Effect<B> { callback in self.run { a in callback(f(a)) } }
  }
}

// Here is what Effect allows us to do.
// This function returns a int value after 2 seconds.
//let aIntInTwoSeconds = Effect<Int> { callback in
//  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    callback(42)
//  }
//}

// no work is done immediately, it only does work when we decide to run it.
//aIntInTwoSeconds.run { int in print(int) }

// Effect also has a map function that allows us do anything on the stored value in the effect.
//aIntInTwoSeconds.map { $0 * $0 }.run { int in print(int) }




// Let's recreate the effect with combine from first principles.

// Turns out the `Publisher` is a protocol
// Publisher.init

// Only has one initializer of a type that conforms to Protocol
// AnyPublisher.init(<#T##publisher: Publisher##Publisher#>)


// Let's look at one concrete implementation of Publisher we have.
// Gives us the functionality of the Iterator protocol underneath.
//var count = 0
//let iterator = AnyIterator<Int>.init {
//  count += 1
//  return count
//}
//
//Array(iterator.prefix(10))


// Another concrete type we have is called `Future`
// This comes with a callback based initialiser just like the effect type did.

// We have to specify the two types of the Result before we can initialise it
// We use Never meaning this thing can never fail
let aFutureInt = Deferred {
  Future<Int, Never> { callback in
    // we add asynchrony to the operation as we did above.
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      print("hello from the future")
      callback(.success(42))
    }
  }
}

// previously we use run to access the value from effect.
// to get a value out of a future, we have to subscribe to it.
// Just like Publisher - Subscriber is a protocol.
// Luckily we have AnySubscriber which has an initializer and takes in 3 closure arguments which allow us to hook in to various lifecycle events for one of the publishers
// receiveSubscription - allows us to be notified when a subscriber is attached to a publisher. we can use the Subscription object to signal how many values we may want from the publisher
// receiveValue - this is called the moment the publisher delivers a value, so that we can do something with that value. it returns this Demand which allow us to tell the publisher how many values we want from them.
// receiveCompletion - fires this method the moment a publisher finishes. this indicates whether it finishes successfully or that it finishes with a failure
//aFutureInt.subscribe(
//  AnySubscriber<Int, Never>.init(
//    receiveSubscription: { subscription in
//      print("subscription")
//      // subscription.cancel() // just to demonstrate what we can do.
//      subscription.request(.unlimited)
//    },
//    receiveValue: { value in
//      print("value", value)
//      // this too needs to return a Demand
//      return .unlimited
//    },
//    receiveCompletion: { completion in
//      print("completion", completion)
//    }
//  )
//)

// All the above looks like a lot but although powerful we don't need a lot of them right now.
// Luckily combine ships with a more convenient way to get values out of publishers.
// A publisher has two methods called sink: they allow you to get a value from a publisher by tapping only into the received value and receive completion events. you don't get access to the actual subscription and you don't get to control the demand (it just assumes unlimited demand).

// here is an example if you only care about the value.
//aFutureInt.sink { int in
//  print(int)
//}

// running it at first doesn't print anything.
// That's because combine has this concept called `Cancellable`.
// whereas the subscribe function doesn't return anything, sink does, and this returned value is allowing us to cancel future values from being delivered to our sink, since we're not holding on to the value, it's getting deallocated immediately and that cancels the subscription.
// The type of the return value is `AnyCancellable`, yet another one of those Any wrappers but this time for the Cancellable protocol and if we hold on to it we will finally get the value delivered.

let cancellable = aFutureInt.sink { int in
  print(int)
}
//cancellable.cancel() // if we immediately cancel the cancellable it never prints out the integer.


// Introducing `Subject`

// Subject.init - Subject is also protocol

// Some concrete impelementation of Subject provided
let passthrough = PassthroughSubject<Int, Never>.init()
let currentValue = CurrentValueSubject<Int, Never>.init(2)

let c1 = passthrough.sink { x in
  print("passthrough", x)
}

let c2 = currentValue.sink { x in
  print("currentValue", x)
}

passthrough.send(42)
currentValue.send(1729)

//: [Next](@next)
