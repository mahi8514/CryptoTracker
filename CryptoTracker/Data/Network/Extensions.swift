//
//  Extensions.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

extension String {
    var url: URL? {
        URL(string: self)
    }
}

extension URLComponents {

    init?(service: ServiceProtocol) {
        guard let baseURL = service.baseURL else { return nil }
        let url = baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!
        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .url else { return }
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}

extension URLRequest {

    init?(service: ServiceProtocol) {
        guard let urlComponents =  URLComponents(service: service) else { return nil }
        self.init(url: urlComponents.url!)
        httpMethod = service.method.rawValue
        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
        if case let .upload(data) = service.task, service.parametersEncoding == .data {
            httpBody = data
            return
        }
        if case let .requestParameters(parameters) = service.task, service.parametersEncoding == .json {
            httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            return
        }
    }
}
