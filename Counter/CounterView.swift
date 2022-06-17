//
//  CounterView.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import ComposableArchitecture
import SwiftUI
import PrimeModal

public struct CounterViewState: Equatable {
  public var alertNthPrime: PrimeAlert?
  public var count: Int
  public var favoritePrimes: [Int]
  public var isNthPrimeButtonDisabled: Bool
  
  public init(
    alertNthPrime: PrimeAlert? = nil,
    count: Int = 0,
    favoritePrimes: [Int] = [],
    isNthPrimeButtonDisabled: Bool = false
  ) {
    self.alertNthPrime = alertNthPrime
    self.count = count
    self.favoritePrimes = favoritePrimes
    self.isNthPrimeButtonDisabled = isNthPrimeButtonDisabled
  }
  
  var counter: CounterState {
    get { (self.alertNthPrime, count, isNthPrimeButtonDisabled) }
    set { (self.alertNthPrime, count, isNthPrimeButtonDisabled) = newValue }
  }
  
  var primeModal: PrimeModalState {
    get { (count, favoritePrimes) }
    set { (count, favoritePrimes) = newValue }
  }
}

public enum CounterViewAction: Equatable {
  case counter(CounterAction)
  case primeModal(PrimeModalAction)
  
  var counter: CounterAction? {
    get {
      guard case let .counter(value) = self else { return nil }
      return value
    }
    set {
      guard case .counter = self, let newValue = newValue else { return }
      self = .counter(newValue)
    }
  }
  
  var primeModal: PrimeModalAction? {
    get {
      guard case let .primeModal(value) = self else { return nil }
      return value
    }
    set {
      guard case .primeModal = self, let newValue = newValue else { return }
      self = .primeModal(newValue)
    }
  }
}

public struct CounterView: View {
  @ObservedObject var store: Store<CounterViewState, CounterViewAction>
  @State var isPrimeModalShown = false
//  @State var alertNthPrime: PrimeAlert?
//  @State var isNthPrimeButtonDisabled = false
  
  public init(store: Store<CounterViewState, CounterViewAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      HStack {
        Button("-") { self.store.send(.counter(.decrTapped)) }
        Text("\(self.store.value.count)")
        Button("+") { self.store.send(.counter(.incrTapped)) }
      }
      Button("Is this prime?") { self.isPrimeModalShown = true }
      Button(
        "What is the \(ordinal(self.store.value.count)) prime?",
        action: self.nthPrimeButtonAction
      )
      .disabled(self.store.value.isNthPrimeButtonDisabled)
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .sheet(isPresented: self.$isPrimeModalShown) {
      IsPrimeModalView(
        store: self.store.view(
          value: { PrimeModalState(count: $0.count, favoritePrimes: $0.favoritePrimes) },
          action: { .primeModal($0) }
        )
      )
    }
    .alert(
      item: .constant(self.store.value.alertNthPrime)
    ) { alert in
      Alert(
        title: Text("The \(ordinal(self.store.value.count)) prime is \(alert.prime)"),
        dismissButton: .default(Text("Ok")) {
          self.store.send(.counter(.alertDismissButtonTapped))
        }
      )
    }
  }
  
  func nthPrimeButtonAction() {
//    self.isNthPrimeButtonDisabled = true
//    nthPrime(self.store.value.count) { prime in
//      self.alertNthPrime = prime.map(PrimeAlert.init(prime:))
//      self.isNthPrimeButtonDisabled = false
//    }
    self.store.send(.counter(.nthPrimeButtonTapped))
  }
}

func ordinal(_ n: Int) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .ordinal
  return formatter.string(for: n) ?? ""
}

//struct CounterView_Previews: PreviewProvider {
//
//  static var previews: some View {
//    CounterView(
//      store: Store<CounterViewState, CounterViewAction>(
//        initialValue: CounterViewState(
//          alertNthPrime: nil,
//          count: 0,
//          favoritePrimes: [],
//          isNthPrimeButtonDisabled: false
//        ),
//        reducer: counterViewReducer
//      )
//    )
//  }
//}
