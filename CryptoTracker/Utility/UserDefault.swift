//
//  UserDefault.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?
    let userDefaults: UserDefaults
    
    init(_ key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = UserDefaults.standard
    }
    
    var wrappedValue: T? {
        get { userDefaults.object(forKey: key) as? T ?? defaultValue }
        set {
            if let newValue = newValue {
                userDefaults.setValue(newValue, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}

struct UserDefaultConfig {
    
    @UserDefault("minimumAcceptableRate", defaultValue: nil)
    static var minimumAcceptableRate: Double?
    
    @UserDefault("maximumAcceptableRate", defaultValue: nil)
    static var maximumAcceptableRate: Double?
    
    @UserDefault("latestBitCoinData", defaultValue: nil)
    static var latestBitCoinData: Data?
    
}
