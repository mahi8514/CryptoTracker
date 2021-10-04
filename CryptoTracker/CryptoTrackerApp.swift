//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}
