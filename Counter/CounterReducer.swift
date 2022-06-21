//
//  CounterReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Combine
import ComposableArchitecture
import FavoritePrimes
import Foundation
import PrimeModal

public typealias CounterState = (
  alertNthPrime: PrimeAlert?,
  count: Int,
  isNthPrimeButtonDisabled: Bool
)

/// Reducers which describes all the business logic of our app and
/// broken down into various components.
/// Each is responsible for handling the state and actions of each of the three screens in our app.
public func counterReducer(
  state: inout CounterState,
  action: CounterAction,
  environment: CounterEnvironment
) -> [Effect<CounterAction>] {
  switch action {
  case .decrTapped:
    state.count -= 1
    return []
    
  case .incrTapped:
    state.count += 1
    return []

  case .nthPrimeButtonTapped:
    state.isNthPrimeButtonDisabled = true
    return [
      //  nthPrime(state.count)
      environment.nthPrime(state.count)
      // Cases on enums are basically functions from their associated value to the enum
        .map(CounterAction.nthPrimeResponse)
        .receive(on: DispatchQueue.main)
        .eraseToEffect()
    ]
    
  case let .nthPrimeResponse(prime):
    state.alertNthPrime = prime.map(PrimeAlert.init(prime:))
    state.isNthPrimeButtonDisabled = false
    return []
    
  case .alertDismissButtonTapped:
    state.alertNthPrime = nil
    return []
  }
}

public struct CounterEnvironment {
  var nthPrime: (Int) -> Effect<Int?>
}

extension CounterEnvironment {
  public static let live = CounterEnvironment(nthPrime: Counter.nthPrime)
}

//var Current = CounterEnvironment.live

extension CounterEnvironment {
  static let mock = CounterEnvironment { _ in .sync { 17 } }
}

public let counterViewReducer: Reducer<CounterViewState, CounterViewAction, CounterEnvironment> = combine(
  pullback(
    counterReducer,
    value: \CounterViewState.counter,
    action: \CounterViewAction.counter,
    environment: { $0 }
  ),
  pullback(
    primeModalReducer,
    value: \.primeModal,
    action: \.primeModal,
    environment: { _ in () }
  )
)
