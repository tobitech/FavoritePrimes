//
//  ActivityFeed.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

func activityFeed(
  _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
  
  return { state, action in
    switch action {
    case .counter:
      break
    case .primeModal(.removeFavoritePrimeTapped):
      state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))
      
    case .primeModal(.saveFavoritePrimeTapped):
      state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
      
    case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
      for index in indexSet {
        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.favoritePrimes[index])))
      }
    }
    
    reducer(&state, action)
  }
}
