//
//  Combine.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// One of two functions that form the foundation of reducer composition.
/// This combine function allows us join multiple reducers together into a single mega reducer.
public func combine<Value, Action>(
  _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
  return { value, action in
    let effects = reducers.flatMap { $0(&value, action) }
    return effects
//    return {
//      var finalAction: Action?
//      for effect in effects {
//        if let action = effect() {
//          finalAction = action
//        }
//      }
//
//      return finalAction
//    }
  }
}
