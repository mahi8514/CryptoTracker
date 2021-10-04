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
                self.notifyIfNeeded(with: result)
                DataManager.shared.latestBitCoin = result
                return promise(.success(.success(result)))
            }
            .store(in: &self.cancelBag)
        }
    }
    
    func notifyIfNeeded(with bitcoinResponse: BitcoinResponse) {
        guard let minimumRate = UserDefaultConfig.minimumAcceptableRate, let maximumRate = UserDefaultConfig.maximumAcceptableRate else { return }
        if let latest = DataManager.shared.latestBitCoin {
            // Trigger notification only if there is any change. The best constraint is the date & time. But seconds in time is not updated in API
            if bitcoinResponse.bpi.USD.rateFloat == latest.bpi.USD.rateFloat { return }
        }
        let amount = bitcoinResponse.bpi.USD.rateFloat
        if amount <= minimumRate {
            NotificationManager.shared.showLocalNotification(with: .init(amount: amount, type: .minimum))
        } else if amount >= maximumRate {
            NotificationManager.shared.showLocalNotification(with: .init(amount: amount, type: .maximum))
        }
    }
    
}
