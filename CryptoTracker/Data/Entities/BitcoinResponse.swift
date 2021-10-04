//
//  BitcoinResponse.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

struct BitcoinResponse: Codable {
    let time: Time
    let disclaimer: String
    let chartName: String
    let bpi: BPI
}

struct Time: Codable {
    let updated: String
    let updatedISO: String
    let updateduk: String
}

struct BPI: Codable {
    let USD: Currency
    let GBP: Currency
    let EUR: Currency
}

struct Currency: Codable {
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rateFloat: Double
}
