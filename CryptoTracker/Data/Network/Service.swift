//
//  Service.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

typealias Headers = [String: String]
typealias Parameters = [String: Any]

protocol ServiceProtocol {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: Headers? { get }
    var parametersEncoding: ParametersEncoding { get }
}

enum CryptoService {
    case exchangeRate
}

extension CryptoService: ServiceProtocol {

    var baseURL: URL? {
        URL(string: Constants.Network.baseUrl)
    }

    var path: String {
        switch self {
        case .exchangeRate: return Constants.Network.currentPricePath
        }
    }

    var method: HTTPMethod {
        switch self {
        case .exchangeRate: return .get
        }
    }

//    var parameters: [String: Any]? {
//        var params: [String: Any] = [:]
//        switch self {
//        case .exchangeRate:
//        }
//        return params
//    }
    
    var task: HTTPTask {
        switch self {
        case .exchangeRate: return .requestPlain
        }
    }

    var headers: Headers? {
        switch self {
        case .exchangeRate: return nil
        }
    }

    var parametersEncoding: ParametersEncoding {
        switch self {
        case .exchangeRate: return .url
        }
    }
}

