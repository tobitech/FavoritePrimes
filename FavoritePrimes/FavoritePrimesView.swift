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
    .navigationBarItems(
      trailing: HStack {
        Button("Save") {
          self.store.send(.saveButtonTapped)
//          // In here we will perform the side effect that saves the favourite primes to disk.
//          // we want to be able to serialise the primes.
//          let data = try! JSONEncoder().encode(self.store.value)
//
//          // we want to save this data to a consistent url in the document directory.
//          let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//          let documentsUrl = URL(fileURLWithPath: documentsPath)
//          let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//          try! data.write(to: favoritePrimesUrl)
        }
        
        Button("Load") {
          self.store.send(.loadButtonTapped)
//          let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//          let documentsUrl = URL(fileURLWithPath: documentsPath)
//          let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//          guard let data = try? Data(contentsOf: favoritePrimesUrl),
//                let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data)
//          else { return }
//          self.store.send(.loadedFavoritePrimes(favoritePrimes))
        }

      }
    )
  }
}

//struct FavoritePrimes_Preview: PreviewProvider {
//  static var previews: some View {
//    FavoritePrimesView(
//      store: Store<[Int], FavoritePrimesAction>(
//        initialValue: [],
//        reducer: favoritePrimesReducer
//      )
//    )
//  }
//}
