//
//  NotificationViewModel.swift
//  SwiftUICombineAndData
//
//  Created by Stanly Shiyanovskiy on 24.08.2022.
//

import FirebaseMessaging
import SwiftUI
import UserNotifications

final class NotificationViewModel: ObservableObject {
    
    @Published var permission: UNAuthorizationStatus?
    @AppStorage("subscribeToAllNotifications") var subscribeToAllNotifications: Bool = false {
        didSet {
            if subscribeToAllNotifications {
                subscribeToAllTopics()
            } else {
                unsubscribeFromAllTopics()
            }
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            DispatchQueue.main.async {
                self.permission = permission.authorizationStatus
            }
            
            if permission.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
                if self.subscribeToAllNotifications {
                    self.subscribeToAllTopics()
                } else {
                    self.unsubscribeFromAllTopics()
                }
                
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.unregisterForRemoteNotifications()
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
                
                self.unsubscribeFromAllTopics()
            }
        }
    }
    
    private func subscribeToAllTopics() {
        guard permission == .authorized else { return }
        
        Messaging.messaging().subscribe(toTopic: "all") { error in
            if let error = error {
                print("Error while subscribing: ", error)
                return
            }
            
            print("Subscribed to notifications for all topics")
        }
    }
    
    private func unsubscribeFromAllTopics() {
        Messaging.messaging().unsubscribe(fromTopic: "all") { error in
            if let error = error {
                print("Error while unsubscribing: ", error)
                return
            }
            
            print("Unsubscribed from notifications for all topics")
        }
    }
}
