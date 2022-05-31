//
//  Store.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

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
