//
//  Store.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Combine
import Foundation

struct Parallel<A> {
  let run: (@escaping (A) -> Void) -> Void
}

/// With this signature change to reducers, we've given reducers the ability
/// to do mutation to the value as it needs based on the action that comes in
/// but then it can return a closure that can bundle up some side effecting work
/// that can then be executed later.
public typealias Reducer<Value, Action, Environment> = (inout Value, Action, Environment) -> [Effect<Action>]

/// This is the core library code that powers our app architecture.
/// Store is a container for mutable app state and all the logic that can mutate it.
/// It also reduces our app to SwiftUI by conforming to the `ObservableObject` protocol.
public final class Store<Value, Action>: ObservableObject {
  
  private let reducer: Reducer<Value, Action, Any>
  private let environment: Any
  @Published public private(set) var value: Value
  private var viewCancellable: Cancellable?
  
  private var effectCancellables: Set<AnyCancellable> = []
  
  public init<Environment>(
    initialValue: Value,
    reducer: @escaping Reducer<Value, Action, Environment>,
    environment: Environment
  ) {
    self.reducer = { value, action, environment in
      // force casting here seems safe, because we know we're given a honest reducer with an honest environment.
      // check the exercises to see how we can do type erasure without force casting.
      reducer(&value, action, environment as! Environment)
    }
    self.value = initialValue
    self.environment = environment
  }
  
  public func send(_ action: Action) {
    let effects = self.reducer(&self.value, action, environment)
    effects.forEach { effect in
      var effectCancellable: AnyCancellable?
      var didComplete = false
      effectCancellable = effect.sink(
        receiveCompletion: { [weak self] _ in
          didComplete = true
          guard let effectCancellable = effectCancellable else {
            return
          }
          self?.effectCancellables.remove(effectCancellable)
        },
        receiveValue: self.send
      )
      
      // we only insert the publisher into the set if it doesn't complete immediately.
      if !didComplete, let effectCancellable = effectCancellable {
        effectCancellables.insert(effectCancellable)
      }
    }
  }
  
  public func view<LocalValue, LocalAction>(
    value toLocalValue: @escaping (Value) -> LocalValue,
    action toGlobalAction: @escaping (LocalAction) -> Action
  ) -> Store<LocalValue, LocalAction> {
    let localStore = Store<LocalValue, LocalAction>(
      initialValue: toLocalValue(self.value),
      reducer: { localValue, localAction, _ in
        self.send(toGlobalAction(localAction))
        localValue = toLocalValue(self.value)
        return [] // the act of creating a view shouldn't introduce any new side effect.
      },
      environment: self.environment
    )
    
    localStore.viewCancellable =  self.$value.sink {[weak localStore] newValue in
      localStore?.value = toLocalValue(newValue)
    }

    return localStore
  }
}
