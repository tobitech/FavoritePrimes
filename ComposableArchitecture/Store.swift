//
//  Store.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Combine
import Foundation

/// This is the core library code that powers our app architecture.
/// Store is a container for mutable app state and all the logic that can mutate it.
/// It also reduces our app to SwiftUI by conforming to the `ObservableObject` protocol.
public final class Store<Value, Action>: ObservableObject {
  private let reducer: (inout Value, Action) -> Void
  @Published public private(set) var value: Value
  private var cancellable: Cancellable?
  
  public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }
  
  public func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
  
  public func view<LocalValue, LocalAction>(
    value toLocalValue: @escaping (Value) -> LocalValue,
    action toGlobalAction: @escaping (LocalAction) -> Action
  ) -> Store<LocalValue, LocalAction> {
    let localStore = Store<LocalValue, LocalAction>(
      initialValue: toLocalValue(self.value),
      reducer: { localValue, localAction in
        self.send(toGlobalAction(localAction))
        localValue = toLocalValue(self.value)
      }
    )
    
    localStore.cancellable =  self.$value.sink {[weak localStore] newValue in
      localStore?.value = toLocalValue(newValue)
    }

    return localStore
  }
  
//  func ___<LocalAction>(
//    _ f: @escaping (LocalAction) -> Action
//  ) -> Store<Value, LocalAction> {
//    return Store<Value, LocalAction>(
//      initialValue: self.value,
//      reducer: { value, localAction in
//        self.send(f(localAction))
//        value = self.value
//      }
//    )
//  }
}
