//
//  Session.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    func dataTask(request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest) -> URLSession.DataTaskPublisher {
        dataTaskPublisher(for: request)
    }
}
