//
//  Enums.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPTask {
    case requestPlain
    case requestParameters(Parameters)
    case upload(Data)
}

enum ParametersEncoding {
    case url
    case json
    case data
}

enum NetworkError: Error, Equatable {
    case badURL
    case apiError(code: Int)
    case invalidJSON
    case unauthorized(code: Int)
    case badRequest(code: Int)
    case serverError(code: Int)
    case noResponse
    case notFound
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .badURL: return "Invalid URL"
        case .apiError(let code): return "\(code) API Error"
        case .invalidJSON: return "Cannot parse the data. Invalid JSON"
        case .unauthorized(let code): return "\(code) Unauthorized"
        case .badRequest(let code): return "\(code) Bad Request"
        case .serverError(let code): return "\(code) Server Error"
        case .noResponse: return "No response from Server"
        case .notFound: return "Not Found. URL may be expired."
        case .unknown: return "Unknown Error"
        }
    }
}
