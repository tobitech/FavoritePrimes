//
//  Logging.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Combine
import Foundation

/// A higher order reducer - which are functions that takes reducer as input
/// and returns reducer as ouput.
/// This allows us address app level concerns like logging in a central way that doesn't polute our other local reducers.
//public func logging<Value, Action, Environment>(
//  _ reducer: Reducer<Value, Action, Environment>
//) -> Reducer<Value, Action, Environment> {
//  .init { value, action, environment in
//    let effects = reducer(&value, action, environment)
//
//    // cause printing is an effect
//    let newValue = value // we're doing this because compiler doesn't allow inout parameters to be passed down in an escaping closure.
//    return [Effect.fireAndForget {
//      print("Action: \(action)")
//      print("Value:")
//      dump(newValue)
//      print("---")
//    }] + effects
//  }
//}

extension Reducer {
  public func logging(
    // this allows us pluck out any logger from our Environment
    // you can use the default value if you don't want to use a environment printer.
    printer: @escaping (Environment) -> (String) -> Void = { _ in { print($0) } }
  ) -> Reducer {
    .init { value, action, environment in
      let effects = self(&value, action, environment)
      
      // cause printing is an effect
      let newValue = value // we're doing this because compiler doesn't allow inout parameters to be passed down in an escaping closure.
      let print = printer(environment)
      return [Effect.fireAndForget {
        print("Action: \(action)")
        print("Value:")
        var dumpedNewValue = ""
        dump(newValue, to: &dumpedNewValue)
        print(dumpedNewValue)
        print("---")
      }] + effects
    }
  }
}

extension Effect {
  public static func fireAndForget(work: @escaping () -> Void) -> Effect {
    return Deferred { () -> Empty<Output, Never> in
      work()
      return Empty(completeImmediately: true)
    }.eraseToEffect()
  }
}
