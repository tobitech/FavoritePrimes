//
//  CounterReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// Reducers which describes all the business logic of our app and
/// broken down into various components.
/// Each is responsible for handling the state and actions of each of the three screens in our app.
public func counterReducer(state: inout Int, action: CounterAction) {
  switch action {
  case .decrTapped:
    state -= 1
    
  case .incrTapped:
    state += 1
  }
}
