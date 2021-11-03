//
//  NotificationManager.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation
import UserNotifications

struct NotificationModel {
    
    enum ExceedType {
        case minimum, maximum
        
        var title: String {
            switch self {
            case .minimum: return "Minimum"
            case .maximum: return "Maximum"
            }
        }
    }
    var amount: Double
    var type: ExceedType
    
    var title: String {
        "Its \(type.title)"
    }
    
    var subtitle: String {
        switch type {
        case .minimum: return "Bitcoin price is below . Current price is \(amount.usd)"
        case .maximum: return "Bitcoin price is above . Current price is \(amount.usd)"
        }
    }
}

class NotificationManager {
    
    static let shared: NotificationManager = NotificationManager()
    
    private init() {  }
    
    func notifyIfNeeded(with bitcoinResponse: BitcoinResponse) {
        guard let minimumRate = UserDefaultConfig.minimumAcceptableRate, let maximumRate = UserDefaultConfig.maximumAcceptableRate else { return }
        if let latest = DataManager.shared.latestBitCoin {
            // Trigger notification only if there is any change. The best constraint is the date & time. But seconds in time is not updated in API
            if bitcoinResponse.bpi.USD.rateFloat == latest.bpi.USD.rateFloat { return }
        }
        let amount = bitcoinResponse.bpi.USD.rateFloat
        if amount <= minimumRate {
            showLocalNotification(with: .init(amount: amount, type: .minimum))
        } else if amount >= maximumRate {
            showLocalNotification(with: .init(amount: amount, type: .maximum))
        }
    }
    
    private func showLocalNotification(with model: NotificationModel) {
        let content = UNMutableNotificationContent()
        content.title = model.title
        content.subtitle = model.subtitle
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}
