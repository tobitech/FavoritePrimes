//
//  FavoritePrimesApp.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture
import Counter
import FavoritePrimes
import PrimeModal
import SwiftUI

struct AppEnvironment {
  var counter: CounterEnvironment
  var favoritePrimes: FavoritePrimesEnvironment
}

/// Each of our app's reducers is put together in our App's mega reducer by pulling back each of this more focused reducers and combining them.
let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
  pullback(
    counterViewReducer,
    value: \AppState.counterView,
    action: \AppAction.counterView,
    environment: { $0.counter }
  ),
  pullback(
    favoritePrimesReducer,
    value: \.favoritePrimes,
    action: \.favoritePrimes,
    environment: { $0.favoritePrimes }
  )
)

//let appReducer = pullback(_appReducer, value: \.self, action: \.self)

@main
struct PrimeTimeApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store<AppState, AppAction>(
          initialValue: AppState(),
          reducer: with(
            appReducer,
            compose(
              logging,
              activityFeed
            )
          ),
          environment: AppEnvironment(
            counter: .live,
            favoritePrimes: .live
          )
        )
      )
    }
  }
}
