//
//  CounterReducer.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

func counterReducer(state: inout Int, action: CounterAction) {
  switch action {
  case .decrTapped:
    state -= 1
    
  case .incrTapped:
    state += 1
  }
}
