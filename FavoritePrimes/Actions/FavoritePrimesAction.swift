//
//  FavoritePrimesAction.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

enum FavoritePrimesAction {
  case deleteFavoritePrimes(IndexSet)
  
  var deleteFavoritePrimes: IndexSet? {
    get {
      guard case let .deleteFavoritePrimes(value) = self else { return nil }
      return value
    }
    set {
      guard case .deleteFavoritePrimes = self, let newValue = newValue else { return }
      self = .deleteFavoritePrimes(newValue)
    }
  }
}
