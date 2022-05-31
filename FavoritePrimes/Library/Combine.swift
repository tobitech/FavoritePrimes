//
//  Combine.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

func combine<Value, Action>(
  _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
  return { value, action in
    for reducer in reducers {
      reducer(&value, action)
    }
  }
}
