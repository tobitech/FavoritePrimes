//
//  PrimeAlert.swift
//  FavoritePrimes
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

struct PrimeAlert: Identifiable {
  let prime: Int
  var id: Int { self.prime }
}
