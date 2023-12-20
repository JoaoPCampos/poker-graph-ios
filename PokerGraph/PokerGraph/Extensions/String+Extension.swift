//
//  String+Extension.swift
//  PokerGraph
//
//  Created by João Campos on 20/12/2023.
//

import Foundation

extension String {

  func asCGFloat() -> CGFloat {

      guard let doubleValue = Double(self) else {
          assertionFailure("unable to convert \(self) to float")
          return 0
    }

    return CGFloat(doubleValue)
  }
}
