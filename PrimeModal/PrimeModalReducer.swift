//
//  PrimeModalReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture

public typealias PrimeModalState = (count: Int, favoritePrimes: [Int])

public func primeModalReducer(state: inout PrimeModalState, action: PrimeModalAction) -> [Effect<PrimeModalAction>] {
  switch action {
  case .removeFavoritePrimeTapped:
    state.favoritePrimes.removeAll(where: { $0 == state.count })
    return []
    
  case .saveFavoritePrimeTapped:
    state.favoritePrimes.append(state.count)
    return []
  }
}
