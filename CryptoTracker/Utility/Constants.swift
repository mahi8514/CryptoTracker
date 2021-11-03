//
//  Constants.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

struct Constants {
    
    struct Identifiers {
        static let backgroundRefreshTaskId = "com.cryptotracker.refresh"
        static let backgroundURLSessionId = "com.cryptotracker.bg_urlsession"
    }
    
    struct Network {
        static let baseUrl = "https://api.coindesk.com"
        static let currentPricePath = "/v1/bpi/currentprice.json"
    }
    
}
