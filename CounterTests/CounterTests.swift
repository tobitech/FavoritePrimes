//
//  CounterTests.swift
//  CounterTests
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import XCTest
@testable import Counter

class CounterTests: XCTestCase {
  func testIncrButtonTapped() {
    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )
    
    let effects = counterViewReducer(&state, .counter(.incrTapped))
    
    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 3,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    
    XCTAssert(effects.isEmpty)
  }
  
  func testDecrButtonTapped() {
    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )
    
    let effects = counterViewReducer(&state, .counter(.decrTapped))
    
    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 1,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    
    XCTAssert(effects.isEmpty)
  }
  
  func testNthPrimeButtonFlow() {
    var state = CounterViewState(
      alertNthPrime: nil,
      count: 2,
      favoritePrimes: [3, 5],
      isNthPrimeButtonDisabled: false
    )
    
    var effects = counterViewReducer(&state, .counter(.nthPrimeButtonTapped))
    
    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: true
      )
    )
    
    XCTAssertEqual(effects.count, 1)
    
    effects = counterViewReducer(&state, .counter(.nthPrimeResponse(3)))
    
    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: PrimeAlert(prime: 3),
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    
    XCTAssertTrue(effects.isEmpty)
    
    effects = counterViewReducer(&state, .counter(.alertDismissButtonTapped))
    
    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    
    XCTAssertTrue(effects.isEmpty)
  }
}
