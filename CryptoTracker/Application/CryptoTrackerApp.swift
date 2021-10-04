//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(bitcoinService: DefaultBitcoinService()))
        }
    }
}
