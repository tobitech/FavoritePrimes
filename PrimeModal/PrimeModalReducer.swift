//
//  PrimeModalReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture

public typealias PrimeModalState = (count: Int, favoritePrimes: [Int])

public func primeModalReducer(
  state: inout PrimeModalState,
  action: PrimeModalAction,
  environment: Void // Void signifies an environment that isn't meaningful and doesn't need anything to do its job.
) -> [Effect<PrimeModalAction>] {
  switch action {
  case .removeFavoritePrimeTapped:
    state.favoritePrimes.removeAll(where: { $0 == state.count })
    return []
    
  case .saveFavoritePrimeTapped:
    state.favoritePrimes.append(state.count)
    return []
  }
}
