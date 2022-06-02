//
//  ActivityFeed.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// Another higher order reducer that is a bit more domain specific.
/// This is responsible for appending activities to our app's state activities upon receiving certain actions.
func activityFeed(
  _ reducer: @escaping (inout AppState, AppAction) -> Void
) -> (inout AppState, AppAction) -> Void {
  
  return { state, action in
    switch action {
    case .counterView(.counter),
        .favoritePrimes(.loadedFavoritePrimes):
      break
    case .counterView(.primeModal(.removeFavoritePrimeTapped)):
      state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))
      
    case .counterView(.primeModal(.saveFavoritePrimeTapped)):
      state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
      
    case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
      for index in indexSet {
        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.favoritePrimes[index])))
      }
    }
    
    reducer(&state, action)
  }
}
