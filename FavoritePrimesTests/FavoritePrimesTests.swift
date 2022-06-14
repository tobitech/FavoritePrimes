//
//  FavoritePrimesTests.swift
//  FavoritePrimesTests
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import XCTest
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
  func testDeleteFavoritePrimes() throws {
    var state = [2, 3, 5, 7]
    
    let effects = favoritePrimesReducer(
      state: &state,
      action: .deleteFavoritePrimes([2])
    )
    
    XCTAssertEqual(state, [2, 3, 7])
    XCTAssert(effects.isEmpty)
  }
  
  func testSaveButtonTapped() throws {
    var state = [2, 3, 5, 7]
    
    let effects = favoritePrimesReducer(
      state: &state,
      action: .saveButtonTapped
    )
    
    XCTAssertEqual(state, [2, 3, 5, 7])
    
    // we will find a better way of handling this soon.
    // cause we need to test that the side effect worked
    // right now we just test that an effect was produced by the action.
    XCTAssertEqual(effects.count, 1)
  }
  
  func testLoadLoadFavoritePrimesFlow() throws {
    var state = [2, 3, 5, 7]
    
    var effects = favoritePrimesReducer(
      state: &state,
      action: .loadButtonTapped
    )
    
    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)
    
    // we know that the effect produces another effect.
    effects = (favoritePrimesReducer(state: &state, action: .loadedFavoritePrimes([2, 31])))
    
    XCTAssertEqual(state, [2, 31])
    XCTAssert(effects.isEmpty)
  }
}
