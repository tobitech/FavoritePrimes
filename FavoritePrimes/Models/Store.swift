//
//  Store.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// This is the core library code that powers our app architecture.
/// Store is a container for mutable app state and all the logic that can mutate it.
/// It also reduces our app to SwiftUI by conforming to the `ObservableObject` protocol.
final class Store<Value, Action>: ObservableObject {
  let reducer: (inout Value, Action) -> Void
  @Published private(set) var value: Value
  
  init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }
  
  func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
}
