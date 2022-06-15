//
//  FavoritePrimesReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Combine
import ComposableArchitecture
import Foundation

public func favoritePrimesReducer(state: inout [Int], action: FavoritePrimesAction) -> [Effect<FavoritePrimesAction>] {
  switch action {
  case let .deleteFavoritePrimes(indexSet):
    for index in indexSet {
      state.remove(at: index)
    }
    return []
    
  case let .loadedFavoritePrimes(favoritePrimes):
    state = favoritePrimes
    return []
    
  case .saveButtonTapped:
    //    let state = state - no longer needed since we're passing an immutable value in below
    return [
//      saveEffect(favoritePrimes: state)
      Current.fileClient.save("favorite-primes.json", try! JSONEncoder().encode(state))
        .fireAndForget()
    ]
    
  case .loadButtonTapped:
    return [
//      loadEffect
//        .compactMap { $0 }
//        .eraseToEffect()
      Current.fileClient.load("favorite-primes.json")
        .compactMap { $0 }
        .decode(type: [Int].self, decoder: JSONDecoder())
        .catch { error in Empty(completeImmediately: true) }
        .map(FavoritePrimesAction.loadedFavoritePrimes)
        .eraseToEffect()
    ]
  }
}

// (Never) -> A

//func absurd<A>(_ never: Never) -> A {
//  switch never { }
//}

// Swift is now smart that we don't even have to included the body
// this is what we need to convert our Effect of Never to Effect of FavoritePrimesAction.
func absurd<A>(_ never: Never) -> A {}

// Turn the functionality above to a helper function
extension Publisher where Output == Never, Failure == Never {
  func fireAndForget<A>() -> Effect<A> {
    return self.map(absurd).eraseToEffect()
  }
}


struct FileClient {
  // optional because the file may not exist on disk
  // we're a not using Effect<FavoritePrimesAction> so that the FileClient is not tightly coupled with the favorite primes module and in the future we can extract it into its own module.
  var load: (String) -> Effect<Data?>
  // the method produces a fire and forget effect.
  // we're using Never (defined in Swift standard library because it represents a type that can never be constructed.
  var save: (String, Data) -> Effect<Never>
}

// let's make a live version of the FileClient
extension FileClient {
  static let live = FileClient(
    load: { fileName in
        .sync {
          let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
          let documentsUrl = URL(fileURLWithPath: documentsPath)
          let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
          return try? Data(contentsOf: favoritePrimesUrl)
        }
    },
    save: { fileName, data in
      return .fireAndForget {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentsPath)
        let favoritePrimesUrl = documentsUrl.appendingPathComponent(fileName)
        try! data.write(to: favoritePrimesUrl)
      }
    }
  )
}


struct FavoritePrimesEnvironment {
  var fileClient: FileClient
}

extension FavoritePrimesEnvironment {
  static let live = FavoritePrimesEnvironment(fileClient: .live)
}

var Current = FavoritePrimesEnvironment.live


// MARK: - Lightweight Dependency Injection refresher.
//struct Environment {
//  var date: () -> Date
//}
//
//extension Environment {
//  static let live = Environment { Date() }
//}
//
//extension Environment {
//  static let mock = Environment { Date(timeIntervalSince1970: 1234567890) }
//}
//
//// global variable that represents the live implementation
//#if DEBUG
//var Current = Environment.live
//#else
//let Current = Environment.live
//#endif

//private func saveEffect(favoritePrimes: [Int]) -> Effect<FavoritePrimesAction> {
//  return .fireAndForget {
//    // In here we will perform the side effect that saves the favourite primes to disk.
//    // we want to be able to serialise the primes.
//    let data = try! JSONEncoder().encode(favoritePrimes)
//
//    // we want to save this data to a consistent url in the document directory.
//    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    let documentsUrl = URL(fileURLWithPath: documentsPath)
//    let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//    try! data.write(to: favoritePrimesUrl)
//  }
//}

// Let's create an asynchronous effect helper type, similar to the fireAndForget helper.
extension Effect {
  static func sync(work: @escaping () -> Output) -> Effect {
    return Deferred {
      Just(work())
    }.eraseToEffect()
  }
}


//private let loadEffect = Effect<FavoritePrimesAction?>.sync {
//  let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//  let documentsUrl = URL(fileURLWithPath: documentsPath)
//  let favoritePrimesUrl = documentsUrl.appendingPathComponent("favorite-primes.json")
//  guard let data = try? Data(contentsOf: favoritePrimesUrl),
//        let favoritePrimes = try? JSONDecoder().decode([Int].self, from: data)
//  else { return nil }
//
//  return .loadedFavoritePrimes(favoritePrimes)
//}
