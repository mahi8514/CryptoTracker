//
//  BitcoinService.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation
import Combine

protocol BitcoinService {
    func exchangeRate() -> Future<Result<BitcoinResponse, NetworkError>, Never>
}

class DefaultBitcoinService: BitcoinService {
    
    var cancelBag = Set<AnyCancellable>()
    
    func exchangeRate() -> Future<Result<BitcoinResponse, NetworkError>, Never> {
        let exchangeRatePublisher: AnyPublisher<BitcoinResponse, NetworkError> = CryptoProvider.shared.request(service: .exchangeRate)
        return Future { promise in
            exchangeRatePublisher.sink { completion in
                switch completion {
                case .finished: print("Execution completed")
                case .failure(let error):
                    print(error.localizedDescription)
                    return promise(.success(.failure(error)))
                }
            } receiveValue: { result in
                return promise(.success(.success(result)))
            }
            .store(in: &self.cancelBag)
        }
    }
    
}
