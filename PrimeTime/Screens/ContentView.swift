//
//  ContentView.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture
import Counter
import FavoritePrimes
import SwiftUI

struct ContentView: View {
  @ObservedObject var store: Store<AppState, AppAction>
  
  var body: some View {
    NavigationView {
      List {
        NavigationLink(
          "Counter demo",
          destination: CounterView(
            store: self.store.view(
              value: { $0.counterView },
              action: { .counterView($0) }
            )
          )
        )
        NavigationLink(
          "Favorite primes",
          destination: FavoritePrimesView(
            store: self.store.view(
              value: { $0.favoritePrimes },
              action: { .favoritePrimes($0) }
            )
          )
        )
      }
      .navigationBarTitle("State management")
    }
  }
}

//struct ContentView_Previews: PreviewProvider {
//
//  static var previews: some View {
//    ContentView(
//      store: Store(
//        initialValue: AppState(),
//        reducer: with(
//          appReducer,
//          compose(
//            logging,
//            activityFeed
//          )
//        )
//      )
//    )
//  }
//}
