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
    
    func showLocalNotification(with model: NotificationModel) {
        let content = UNMutableNotificationContent()
        content.title = model.title
        content.subtitle = model.subtitle
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}
