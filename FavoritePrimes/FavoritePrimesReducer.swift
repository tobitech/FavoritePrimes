//
//  FavoritePrimesReducer.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Combine
import ComposableArchitecture
import Foundation

public func favoritePrimesReducer(
  state: inout [Int],
  action: FavoritePrimesAction,
  environment: FavoritePrimesEnvironment
) -> [Effect<FavoritePrimesAction>] {
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
      environment.fileClient.save("favorite-primes.json", try! JSONEncoder().encode(state))
        .fireAndForget()
    ]
    
  case .loadButtonTapped:
    return [
      environment.fileClient.load("favorite-primes.json")
        .compactMap { $0 }
        .decode(type: [Int].self, decoder: JSONDecoder())
        .catch { error in Empty(completeImmediately: true) }
        .map(FavoritePrimesAction.loadedFavoritePrimes)
//        .merge(with: Empty(completeImmediately: false))
      // Exercise - Strengthen the loadButtonTapped test method to not allow the same event twice. i.e. we are only expecting one loadedFavoritePrimes action but the test passes with the code below which is not supposed to be.
        .merge(with: Just(FavoritePrimesAction.loadedFavoritePrimes([2, 31])))
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


public struct FavoritePrimesEnvironment {
  var fileClient: FileClient
}

extension FavoritePrimesEnvironment {
  public static let live = FavoritePrimesEnvironment(fileClient: .live)
}

//var Current = FavoritePrimesEnvironment.live

// let's create a mock version of fileclient so we can use in our tests
// so that this mock code is only availabe in debug mode. (tests and playground)
// and won't be accessible when running the code in live environment.
#if DEBUG
extension FavoritePrimesEnvironment {
  static let mock = FavoritePrimesEnvironment(
    fileClient: FileClient(
      load: { _ in
        Effect<Data?>.sync {
          try! JSONEncoder().encode([2, 31])
        }
      },
      save: { _, _ in
          .fireAndForget {}
      }
    )
  )
}
#endif

// Let's create an asynchronous effect helper type, similar to the fireAndForget helper.
extension Effect {
  public static func sync(work: @escaping () -> Output) -> Effect {
    return Deferred {
      Just(work())
    }.eraseToEffect()
  }
}
