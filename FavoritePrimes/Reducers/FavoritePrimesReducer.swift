//
//  FavoritePrimesReducer.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) {
  switch action {
  case let .deleteFavoritePrimes(indexSet):
    for index in indexSet {
      state.remove(at: index)
    }
  }
}
