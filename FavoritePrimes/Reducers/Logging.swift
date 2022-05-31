//
//  Logging.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

func logging<Value, Action>(
  _ reducer: @escaping (inout Value, Action) -> Void
) -> (inout Value, Action) -> Void {
  return { value, action in
    reducer(&value, action)
    print("Action: \(action)")
    print("Value:")
    dump(value)
    print("---")
  }
}
