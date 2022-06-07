//
//  CounterReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation
import ComposableArchitecture
import PrimeModal

public typealias CounterState = (
  alertNthPrime: PrimeAlert?,
  count: Int,
  isNthPrimeButtonDisabled: Bool
)

/// Reducers which describes all the business logic of our app and
/// broken down into various components.
/// Each is responsible for handling the state and actions of each of the three screens in our app.
public func counterReducer(state: inout CounterState, action: CounterAction) -> [Effect<CounterAction>] {
  switch action {
  case .decrTapped:
    state.count -= 1
    return []
    
  case .incrTapped:
    state.count += 1
    return []
    
  case .nthPrimeButtonTapped:
    state.isNthPrimeButtonDisabled = true
    let count = state.count
    return [{ callback in
      nthPrime(count) { prime in
        DispatchQueue.main.async {
          callback(.nthPrimeResponse(prime))
        }
      }
//      var p: Int?
//      // our effects right now work synchronously
//      // so we need a way to convert this asynchronous code to a synchronous form
//      // one way to do that is to use a dispath semaphore
//      let sema = DispatchSemaphore(value: 0)
//      nthPrime(count) { prime in
//        p = prime
//        sema.signal() // only when we get the prime back should the semaphore be signalled.
//      }
//      sema.wait()
//      return .nthPrimeResponse(p)
    }]
    
  case let .nthPrimeResponse(prime):
    state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
    state.isNthPrimeButtonDisabled = false
    return []
    
  case .alertDismissButtonTapped:
    state.alertNthPrime = nil
    return []
  }
}

public let counterViewReducer = combine(
  pullback(counterReducer, value: \CounterViewState.counter, action: \CounterViewAction.counter),
  pullback(primeModalReducer, value: \.primeModal, action: \.primeModal)
)
