//
//  PrimeAlert.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

public struct PrimeAlert: Equatable, Identifiable {
  public let prime: Int
  public var id: Int { self.prime }
}
