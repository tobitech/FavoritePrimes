//
//  Logging.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// A higher order reducer - which are functions that takes reducer as input
/// and returns reducer as ouput.
/// This allows us address app level concerns like logging in a central way that doesn't polute our other local reducers.
func logging<Value, Action>(
  _ reducer: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {
  return { value, action in
    reducer(&value, action)
    print("Action: \(action)")
    print("Value:")
    dump(value)
    print("---")
  }
}
