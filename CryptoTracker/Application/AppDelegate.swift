//
//  AppDelegate.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//

import Foundation
import UIKit
import BackgroundTasks
import Combine

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var cancelBag = Set<AnyCancellable>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerForNotification()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.backgroundRefreshTaskId, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        
        return true
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Constants.backgroundRefreshTaskId)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh task \(error.localizedDescription)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let operation = BlockOperation {
            DefaultBitcoinService().exchangeRate()
                .sink(receiveValue: { result in
                    switch result {
                    case .success(let response): print(response)
                    case .failure(let error): print(error)
                    }
                })
                .store(in: &self.cancelBag)
        }
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }
        
        queue.addOperations([operation], waitUntilFinished: false)
    }
    
    func registerForNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        notificationCenter.delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification received with identifier \(notification.request.identifier)")
        completionHandler([.badge, .sound, .banner])
    }
}
