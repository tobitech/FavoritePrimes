import Combine
import Foundation

public struct Effect<Output>: Publisher {
  
  public typealias Failure = Never
  
  let publisher: AnyPublisher<Output, Failure>
  
  // receive is called when a subscriber is attached to the publisher
  // and this is where we need to do the work to send our values.
  // we don't want to do any concrete work in here just to serve as a wrapper around publishers.
  public func receive<S>(
    subscriber: S
  ) where S : Subscriber, Failure == S.Failure, Output == S.Input {
    self.publisher.receive(subscriber: subscriber)
  }
}

extension Publisher where Failure == Never {
  public func eraseToEffect() -> Effect<Output> {
    return Effect(publisher: self.eraseToAnyPublisher())
  }
}
