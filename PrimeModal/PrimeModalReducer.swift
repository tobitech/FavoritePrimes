//
//  PrimeModalReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

public struct PrimeModalState {
  public var count: Int
  public var favoritePrimes: [Int]
  
  public init(count: Int, favoritePrimes: [Int]) {
    self.count = count
    self.favoritePrimes = favoritePrimes
  }
}

public func primeModalReducer(state: inout PrimeModalState, action: PrimeModalAction) {
  switch action {
  case .removeFavoritePrimeTapped:
    state.favoritePrimes.removeAll(where: { $0 == state.count })
    
  case .saveFavoritePrimeTapped:
    state.favoritePrimes.append(state.count)
  }
}
