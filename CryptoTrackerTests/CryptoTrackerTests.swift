//
//  CryptoTrackerTests.swift
//  CryptoTrackerTests
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import XCTest
@testable import CryptoTracker

class CryptoTrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCurrencyFormatterDollarSymbol() throws {
        let amount = CurrencyManager.shared.usdCurrency(amount: 234)
        let symbolContaines = amount.contains { $0 == "$" }
        XCTAssert(symbolContaines)
    }
    
    func testMinimumAndMaximumValueIsSynced() throws {
        if UserDefaultConfig.minimumAcceptableRate != nil {
            XCTAssertNotNil(UserDefaultConfig.maximumAcceptableRate)
        }
        if UserDefaultConfig.maximumAcceptableRate != nil {
            XCTAssertNotNil(UserDefaultConfig.minimumAcceptableRate)
        }
        if UserDefaultConfig.minimumAcceptableRate == nil {
            XCTAssertNil(UserDefaultConfig.maximumAcceptableRate)
        }
        if UserDefaultConfig.maximumAcceptableRate == nil {
            XCTAssertNil(UserDefaultConfig.minimumAcceptableRate)
        }
    }
    
    

}
