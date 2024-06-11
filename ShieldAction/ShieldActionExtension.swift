//
//  ShieldActionExtension.swift
//  ShieldAction
//
//  Created by Su Lei Yadanar on 6/1/24.
//

import ManagedSettings
import UserNotifications

import Foundation

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            scheduleNotification()
            completionHandler(.defer)
            
                       
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
    private func scheduleNotification() {
           let content = UNMutableNotificationContent()
           content.title = "Action Deferred"
           content.body = "You pressed the secondary button. This action has been deferred."
           content.sound = UNNotificationSound.default

           // Trigger notification after 1 second (for example)
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

           // Create the request
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

           // Schedule the notification
           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Error scheduling notification: \(error)")
               }
           }
       }
}

