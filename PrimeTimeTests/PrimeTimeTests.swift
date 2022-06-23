//
//  PrimeTimeTests.swift
//  PrimeTimeTests
//
//  Created by Oluwatobi Omotayo on 21/06/2022.
//

import XCTest
@testable import PrimeTime
import ComposableArchitecture
@testable import Counter
@testable import FavoritePrimes
@testable import PrimeModal

class PrimeTimeTests: XCTestCase {
  
  func testIntegration() throws {
    // this is messy
    Counter.Current = .mock
    FavoritePrimes.Current = .mock
  }
}
