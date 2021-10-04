//
//  DataManager.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

class DataManager {
    
    static let shared: DataManager = DataManager()
    
    private init() {  }
    
    var latestBitCoin: BitcoinResponse? {
        get {
            guard let latestBitCoinData = UserDefaultConfig.latestBitCoinData else { return nil }
            do {
                return try JSONDecoder().decode(BitcoinResponse.self, from: latestBitCoinData)
            } catch {
                print("Unable to Decode Note (\(error))")
                return nil
            }
        }
        
        set {
            do {
                UserDefaultConfig.latestBitCoinData = try JSONEncoder().encode(newValue)
            } catch {
                print("Unable to Encode data (\(error))")
            }
        }
    }
    
}
