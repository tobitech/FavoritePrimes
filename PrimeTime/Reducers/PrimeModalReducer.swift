//
//  PrimeModalReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

func primeModalReducer(state: inout AppState, action: PrimeModalAction) {
  switch action {
  case .removeFavoritePrimeTapped:
    state.favoritePrimes.removeAll(where: { $0 == state.count })
    
  case .saveFavoritePrimeTapped:
    state.favoritePrimes.append(state.count)
  }
}
