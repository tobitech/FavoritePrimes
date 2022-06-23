//
//  PrimeModalTests.swift
//  PrimeModalTests
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import XCTest
@testable import PrimeModal

class PrimeModalTests: XCTestCase {
  func testSaveFavoritePrimesTapped() throws {
    var state = (count: 2, favoritePrimes: [3, 5])
    
    let effects = primeModalReducer(state: &state, action: .saveFavoritePrimeTapped, environment: ())
    
    // since we're using a tuple, it's expedient we destructure the model
    // in case we add new fields so that we can get a compiler error
    // another option would be to write an XCTAssert helper to work on tuples
    // or go with the struct route option.
    let (count, favoritePrimes) = state
    
    XCTAssertEqual(count, 2)
    XCTAssertEqual(favoritePrimes, [3, 5, 2])
    
    // if we don't test effects that is returned by the reducer, our test story won't be complete.
    // since we know the prime modal screen doesn't generate any effects we assert that it is empty.
    XCTAssert(effects.isEmpty)
  }
  
  func testRemoveFavoritePrimesTapped() throws {
    var state = (count: 3, favoritePrimes: [3, 5])
    
    let effects = primeModalReducer(state: &state, action: .removeFavoritePrimeTapped, environment: ())
    let (count, favoritePrimes) = state
    
    XCTAssertEqual(count, 3)
    XCTAssertEqual(favoritePrimes, [5])
    
    XCTAssert(effects.isEmpty)
  }
}
