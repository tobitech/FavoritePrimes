//
//  Logging.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// A higher order reducer - which are functions that takes reducer as input
/// and returns reducer as ouput.
/// This allows us address app level concerns like logging in a central way that doesn't polute our other local reducers.
public func logging<Value, Action>(
  _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
  return { value, action in
    let effects = reducer(&value, action)
    
    // cause printing is an effect
    let newValue = value // we're doing this because compiler doesn't allow inout parameters to be passed down in an escaping closure.
    return [Effect { _ in
      print("Action: \(action)")
      print("Value:")
      dump(newValue)
      print("---")
    }] + effects
  }
}
