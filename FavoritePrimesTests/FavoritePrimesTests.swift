//
//  FavoritePrimesTests.swift
//  FavoritePrimesTests
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import XCTest
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
  
//  override func setUp() {
//    super.setUp()
//    Current = .mock
//  }
  
  func testDeleteFavoritePrimes() throws {
    var state = [2, 3, 5, 7]
    
    let effects = favoritePrimesReducer(
      state: &state,
      action: .deleteFavoritePrimes([2]),
      environment: FileClient.mock
    )
    
    XCTAssertEqual(state, [2, 3, 7])
    XCTAssert(effects.isEmpty)
  }
  
  // Exercise: We can strengthen this test by checking that the data from the saved method is properly encoded
  // and that will give us more code coverage without doing much work.
  func testSaveButtonTapped() throws {
    // swap in a mock before running this test so that we save ourselves the trouble of trying to find a file path.
    // so that we don't even hit the disk at all.
    // We can just trust that our live implementation will work as long as we pass it the right parameters but we want to verify that the save effect was actually called.
    // We will use a boolean that we will toggle when the save effect is called.
    var didSave = false
    var environment = FileClient.mock
//    Current.fileClient.save = { _, _ in
//        .fireAndForget {
//          didSave = true
//        }
//    }
    environment.save = { _, _ in
        .fireAndForget {
          didSave = true
        }
    }
    
    var state = [2, 3, 5, 7]
    
    let effects = favoritePrimesReducer(
      state: &state,
      action: .saveButtonTapped,
      environment: environment
    )
    
    XCTAssertEqual(state, [2, 3, 5, 7])
    
    // we will find a better way of handling this soon.
    // cause we need to test that the side effect worked
    // right now we just test that an effect was produced by the action.
    XCTAssertEqual(effects.count, 1)
    
    // Now that we've refactor our code to be able to mock dependencies, we want to know what effect was fired not just that there is some effect.
    // We added the XCTFail() to test that we never got an emission from that effect.
    effects[0].sink { _ in XCTFail() } // subscribe to the effect that was called.
    
    XCTAssertTrue(didSave)
  }
  
  func testLoadLoadFavoritePrimesFlow() throws {
//    Current.fileClient.load = { _ in
//      return .sync {
//        try! JSONEncoder().encode([2, 31])
//      }
//    }
    var environment = FileClient.mock
    environment.load = { _ in
      return .sync {
        try! JSONEncoder().encode([2, 31])
      }
    }
    
    
    var state = [2, 3, 5, 7]
    
    var effects = favoritePrimesReducer(
      state: &state,
      action: .loadButtonTapped,
      environment: environment
    )
    
    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)
    
    var nextAction: FavoritePrimesAction!
    let receivedCompletion = self.expectation(description: "receivedCompletion")
    effects[0].sink(
      receiveCompletion: { _ in
        receivedCompletion.fulfill()
      },
      receiveValue: { action in
        XCTAssertEqual(action, .loadedFavoritePrimes([2, 31]))
        nextAction = action
      }
    )
    // taking it one step further to verify that it completes after emitting the next event and didn't fire another event afterwards.
    // we use an expectation for that and fulfill that expectation in the completion block of the sink method.
    // timeout: 0 means we expect it to be synchronous.
    self.wait(for: [receivedCompletion], timeout: 0)
    
    // we know that the effect produces another effect.
    // we are now passing it the actual actual that we retrieved from subscribing to the effect rather than manually constructing the effec that we think will be fedback to the store.
    effects = (favoritePrimesReducer(state: &state, action: nextAction, environment: environment))
    
    XCTAssertEqual(state, [2, 31])
    XCTAssert(effects.isEmpty)
  }
}
