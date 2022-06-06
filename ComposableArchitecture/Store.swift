//
//  Store.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Combine
import Foundation

public typealias Effect<Action> = () -> Action?

/// With this signature change to reducers, we've given reducers the ability
/// to do mutation to the value as it needs based on the action that comes in
/// but then it can return a closure that can bundle up some side effecting work
/// that can then be executed later.
public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]

/// This is the core library code that powers our app architecture.
/// Store is a container for mutable app state and all the logic that can mutate it.
/// It also reduces our app to SwiftUI by conforming to the `ObservableObject` protocol.
public final class Store<Value, Action>: ObservableObject {
  private let reducer: Reducer<Value, Action>
  @Published public private(set) var value: Value
  private var cancellable: Cancellable?
  
  public init(initialValue: Value, reducer: @escaping Reducer<Value, Action>) {
    self.reducer = reducer
    self.value = initialValue
  }
  
  public func send(_ action: Action) {
    let effects = self.reducer(&self.value, action)
    effects.forEach { effect in
      if let action = effect() {
        self.send(action)
      }
    }
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
        return [] // the act of creating a view shouldn't introduce any new side effect.
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
