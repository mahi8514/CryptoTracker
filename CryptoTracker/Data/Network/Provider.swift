//
//  Provider.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation
import Combine

protocol ProviderProtocol {
    func request<T: Codable>(service: CryptoService) -> AnyPublisher<T, NetworkError>
}

final class CryptoProvider: ProviderProtocol {
    
    static var shared: CryptoProvider = CryptoProvider()
    
    var requestTimeOut: Float = 8
    
    private var session: URLSessionProtocol

    private init() { self.session = URLSession.shared }
    
    func request<T>(service: CryptoService) -> AnyPublisher<T, NetworkError> where T : Decodable, T : Encodable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(requestTimeOut)
        guard let request = URLRequest(service: service) else { return Fail<T, NetworkError>(error: .badURL).eraseToAnyPublisher() }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return session.dataTask(request: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.serverError(code: 500)
                }
                switch httpResponse.statusCode {
                case 200...299: return output.data
                case 401: throw NetworkError.unauthorized(code: 401)
                case 404: throw NetworkError.notFound
                default: throw NetworkError.unknown
                }
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { _ in NetworkError.invalidJSON }
            .eraseToAnyPublisher()
            
    }
}
