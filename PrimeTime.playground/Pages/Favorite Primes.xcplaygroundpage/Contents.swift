//: [Previous](@previous)

import ComposableArchitecture
import FavoritePrimes
import Foundation
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.liveView = UIHostingController(
  rootView: FavoritePrimesView(
    store: Store<[Int], FavoritePrimesAction>(
      initialValue: [2, 3, 5, 7],
      reducer: favoritePrimesReducer
    )
  )
)

//: [Next](@next)
