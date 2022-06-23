//
//  ActivityFeed.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture

/// Another higher order reducer that is a bit more domain specific.
/// This is responsible for appending activities to our app's state activities upon receiving certain actions.
func activityFeed(
  _ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {
  
  return { state, action, environment in
    switch action {
    case .counterView(.counter),
        .favoritePrimes(.loadedFavoritePrimes),
        .favoritePrimes(.loadButtonTapped),
        .favoritePrimes(.saveButtonTapped):
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
    
    return reducer(&state, action, environment)
  }
}
