//
//  Store.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// This is the core library code that powers our app architecture.
/// Store is a container for mutable app state and all the logic that can mutate it.
/// It also reduces our app to SwiftUI by conforming to the `ObservableObject` protocol.
public final class Store<Value, Action>: ObservableObject {
  private let reducer: (inout Value, Action) -> Void
  @Published public private(set) var value: Value
  
  public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }
  
  public func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
}
