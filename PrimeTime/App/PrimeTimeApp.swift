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

//struct AppEnvironment {
//  var counter: CounterEnvironment
//  var favoritePrimes: FavoritePrimesEnvironment
//}

// here we will take a union of all the environments.
// we did it this way so that for instance: imagine the FavoritePrimes and Counter module both need access to a common dependency e.g. Calendar, we are able to just pluck out the needed dependencies from the AppEnvironment and put it into the reducers in the pullback
typealias AppEnvironment = (
  fileClient: FileClient,
  nthPrime: (Int) -> Effect<Int?>
)

/// Each of our app's reducers is put together in our App's mega reducer by pulling back each of this more focused reducers and combining them.
let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
  pullback(
    counterViewReducer,
    value: \AppState.counterView,
    action: \AppAction.counterView,
    environment: { $0.nthPrime }
//    environment: { ($0.nthPrime, $0.date) } // passing multiple dependencies needed
  ),
  pullback(
    favoritePrimesReducer,
    value: \.favoritePrimes,
    action: \.favoritePrimes,
    environment: { $0.fileClient }
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
            fileClient: .live,
            nthPrime: Counter.nthPrime
//            counter: .live,
//            favoritePrimes: .live
          )
        )
      )
    }
  }
}
