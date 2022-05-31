//
//  IsPrimeModalView.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture
import SwiftUI

struct IsPrimeModalView: View {
  @ObservedObject var store: Store<AppState, AppAction>
  
  var body: some View {
    VStack {
      if isPrime(self.store.value.count) {
        Text("\(self.store.value.count) is prime 🎉")
        if self.store.value.favoritePrimes.contains(self.store.value.count) {
          Button("Remove from favorite primes") {
            self.store.send(.primeModal(.removeFavoritePrimeTapped))
          }
        } else {
          Button("Save to favorite primes") {
            self.store.send(.primeModal(.saveFavoritePrimeTapped))
          }
        }
      } else {
        Text("\(self.store.value.count) is not prime :(")
      }
    }
  }
}

struct IsPrimeModalView_Previews: PreviewProvider {

  static var previews: some View {
    IsPrimeModalView(
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
