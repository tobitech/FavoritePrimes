//
//  Combine.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

// Introduced in Swift 5.2 where when we have a type of just a function we can add this `callAsFunction` method to invoke the type directly.
extension Reducer {
  func callAsFunction(_ value: inout Value, _ action: Action, _ environment: Environment) -> [Effect<Action>] {
    self.reducer(&value, action, environment)
  }
}

/// One of two functions that form the foundation of reducer composition.
/// This combine function allows us join multiple reducers together into a single mega reducer.
//public func combine<Value, Action, Environment>(
//  _ reducers: Reducer<Value, Action, Environment>...
//) -> Reducer<Value, Action, Environment> {
//  .init { value, action, environment in
//    let effects = reducers.flatMap { $0(&value, action, environment) }
//    return effects
//  }
//}

extension Reducer {
  // generics not needed; they would be inferred from the type we're extending.
  public static func combine(_ reducers: Reducer...) -> Reducer {
    .init { value, action, environment in
      let effects = reducers.flatMap { $0(&value, action, environment) }
      return effects
    }
  }
}
