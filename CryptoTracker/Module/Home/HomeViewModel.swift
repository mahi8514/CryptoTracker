//
//  
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    var cancelBag = Set<AnyCancellable>()
    
    init() {
        addObservables()
    }
    
    func addObservables() { }
    
}

class HomeViewModel: ViewModel {
    
    let bitcoinService: BitcoinService
    
    @Published var exchangeRate: String = "$"
    @Published var minimalAcceptableRate: String = ""
    @Published var maximalAcceptableRate: String = ""
    
    let proceedAction = PassthroughSubject<Void, Never>()
    
    init(bitcoinService: BitcoinService) {
        self.bitcoinService = bitcoinService
        super.init()
        if let latestData = DataManager.shared.latestBitCoin {
            exchangeRate = latestData.bpi.USD.rateFloat.usd
        }
        if let minimumRate = UserDefaultConfig.minimumAcceptableRate {
            minimalAcceptableRate = minimumRate.clean
        }
        if let maximumRate = UserDefaultConfig.maximumAcceptableRate {
            maximalAcceptableRate = maximumRate.clean
        }
    }
    
    override func addObservables() {
        super.addObservables()
        
        proceedAction.sink { [weak self] in
            guard let self = self else { return }
            UserDefaultConfig.minimumAcceptableRate = Double(self.minimalAcceptableRate) ?? nil
            UserDefaultConfig.maximumAcceptableRate = Double(self.maximalAcceptableRate) ?? nil
        }
        .store(in: &cancelBag)
        
        let timer = Timer.TimerPublisher(interval: 5.0, runLoop: .main, mode: .default)
        _ = timer.connect()

        timer.map { _ in () }
            .map { [weak self] _ -> Future<Result<BitcoinResponse, NetworkError>, Never> in
                guard let self = self else { return Future { $0(.success(.failure(.unknown))) } }
                return self.bitcoinService.exchangeRate() }
            .switchToLatest()
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let response): self?.exchangeRate = response.bpi.USD.rateFloat.usd
                case .failure(let error): print(error)
                }
            })
            .store(in: &cancelBag)

    }
    
    
    
}
