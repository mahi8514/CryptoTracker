//
//  DatatypeExtension.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

extension Double {
    var usd: String {
        CurrencyManager.shared.usdCurrency(amount: self)
    }
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
