//
//  FavoritePrimesView.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture
import SwiftUI

public struct FavoritePrimesView: View {
  @ObservedObject var store: Store<[Int], FavoritePrimesAction>
  
  public init(store: Store<[Int], FavoritePrimesAction>) {
    self.store = store
  }
  
  public var body: some View {
    List {
      ForEach(self.store.value, id: \.self) { prime in
        Text("\(prime)")
      }
      .onDelete { indexSet in
        self.store.send(.deleteFavoritePrimes(indexSet))
      }
    }
    .navigationBarTitle("Favorite Primes")
  }
}

//struct FavoritePrimesView_Previews: PreviewProvider {
//
//  static var previews: some View {
//    FavoritePrimesView(
//      store: Store(
//        initialValue: AppState().favoritePrimes,
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
