//
//  FavoritePrimesReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation
import ComposableArchitecture

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) -> [Effect<FavoritePrimesAction>] {
  switch action {
  case let .deleteFavoritePrimes(indexSet):
    for index in indexSet {
      state.remove(at: index)
    }
    return []
    
  case let .loadedFavoritePrimes(favoritePrimes):
    state = favoritePrimes
    return []
    
  case .saveButtonTapped:
//    let state = state - no longer needed since we're passing an immutable value in below
    return [saveEffect(favoritePrimes: state)]

  case .loadButtonTapped:
    return [loadEffect]
  }
}

private func saveEffect(favoritePrimes: [Int]) -> Effect<FavoritePrimesAction> {
  return Effect { _ in
    // In here we will perform the side effect that saves the favourite primes to disk.
    // we want to be able to serialise the primes.
    let data = try! JSONEncoder().encode(favoritePrimes)
    
    // we want to save this data to a consistent url in the document directory.
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let documentsUrl = URL(fileURLWithPath: documentsPath)
    let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
    try! data.write(to: favoritePrimesUrl)
  }
}

private let loadEffect = Effect<FavoritePrimesAction> { callback in
  let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
  let documentsUrl = URL(fileURLWithPath: documentsPath)
  let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
  guard let data = try? Data(contentsOf: favoritePrimesUrl),
        let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data)
  else { return }
  //      self.store.send(.loadedFavoritePrimes(favoritePrimes))
  callback(.loadedFavoritePrimes(favoritePrimes))
}
