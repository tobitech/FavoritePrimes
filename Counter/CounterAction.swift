//
//  CounterAction.swift
//  PrimeTime
//
//  Created by Oluwatobi Omotayo on 31/05/2022.
//

import Foundation

/// Enums that define app actions in various components on the screen.
public enum CounterAction {
  case decrTapped
  case incrTapped
  case nthPrimeButtonTapped
  case nthPrimeResponse(Int?)
  case alertDismissButtonTapped
}
