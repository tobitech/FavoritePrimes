//
//  AppAction.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Counter
import FavoritePrimes
import Foundation
import PrimeModal

/// All the individual screen's action are embedded here.
/// We use a code generation tool to generate what is known as enum properties.
/// These are computed properties that bridge the ergonomic gap between `structs` and `enums` by providing dot syntax access to an enum's associate value.
/// With these properties defined, Swift automatically synthensizes key paths which allows us to pull reducers of location actions back to reducers of global actions.
enum AppAction {
//  case counter(CounterAction)
//  case primeModal(PrimeModalAction)
  case counterView(CounterViewAction)
  case favoritePrimes(FavoritePrimesAction)
  
  public var counterView: CounterViewAction? {
    get {
      guard case let .counterView(value) = self else { return nil }
      return value
    }
    set {
      guard case .counterView = self, let newValue = newValue else { return }
      self = .counterView(newValue)
    }
  }
  
  var favoritePrimes: FavoritePrimesAction? {
    get {
      guard case let .favoritePrimes(value) = self else { return nil }
      return value
    }
    set {
      guard case .favoritePrimes = self, let newValue = newValue else { return }
      self = .favoritePrimes(newValue)
    }
  }
}
