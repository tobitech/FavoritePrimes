//
//  FavoritePrimesApp.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import SwiftUI

/// Each of our app's reducers is put together in our App's mega reducer by pulling back each of this more focused reducers and combining them.
let _appReducer: (inout AppState, AppAction) -> Void = combine(
  pullback(counterReducer, value: \.count, action: \.counter),
  pullback(primeModalReducer, value: \.self, action: \.primeModal),
  pullback(favoritePrimesReducer, value: \.favoritePrimes, action: \.favoritePrimes)
)

let appReducer = pullback(_appReducer, value: \.self, action: \.self)

@main
struct PrimeTimeApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(
          initialValue: AppState(),
          reducer: with(
            appReducer,
            compose(
              logging,
              activityFeed
            )
          )
        )
      )
    }
  }
}
