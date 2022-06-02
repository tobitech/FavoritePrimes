//
//  FavoritePrimesReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation
import ComposableArchitecture

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) -> Effect {
  switch action {
  case let .deleteFavoritePrimes(indexSet):
    for index in indexSet {
      state.remove(at: index)
    }
    return {}
    
  case let .loadedFavoritePrimes(favoritePrimes):
    state = favoritePrimes
    return {}
    
  case .saveButtonTapped:
    let state = state
    return {
      // In here we will perform the side effect that saves the favourite primes to disk.
      // we want to be able to serialise the primes.
      let data = try! JSONEncoder().encode(state)
      
      // we want to save this data to a consistent url in the document directory.
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let documentsUrl = URL(fileURLWithPath: documentsPath)
      let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
      try! data.write(to: favoritePrimesUrl)
    }
  }
}
