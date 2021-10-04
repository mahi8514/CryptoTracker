//
//  
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var exchangeRate: String = ""
    @Published var minimalAcceptableRate: String = ""
    @Published var maximalAcceptableRate: String = ""
    
}
