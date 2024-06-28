//
//  ShieldActionExtension.swift
//  ShieldAction
//
//  Created by Su Lei Yadanar on 6/1/24.
//

import ManagedSettings
import UserNotifications

import Foundation
import DeviceActivity

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    let store = ManagedSettingsStore()
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
    
    private func scheduleBreak(timeOutLength: Int) {
        let center = DeviceActivityCenter()
        let activityName = DeviceActivityName(rawValue: "breakTime")
        let now = Date()
        let start = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
        let end = Calendar.current.dateComponents([.hour, .minute, .second], from: now.advanced(by: Double(timeOutLength < 15*60 ? 15*60 : timeOutLength)))

        let schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: false,
            warningTime: timeOutLength < 15*60 ? DateComponents(minute: 15 - timeOutLength / 60) : nil
        )

        do {
            try center.startMonitoring(activityName, during: schedule)
            print("Break happening")
        } catch let error {
            print("Error starting monitoring: \(error)")
        }
    }

    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        let mode = userDefaults?.string(forKey: "mode")
        
        let parts = userDefaults?.string(forKey: "activeSchedule")
        
        let splitParts = parts?.split(separator: "-")
        
        let hour = splitParts?.count ?? 0 > 2 ? String(splitParts?[2] ??  "") : parts
        
        let minute = splitParts?.count ?? 0 > 3 ? String(splitParts?[3] ??  "0") : parts
        var timeOutLength : Int = 0

        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            print("secondary btn pressed")
            if (mode == "intentional"){
                //   store.shield.applications?.remove(application)
                print("intentional mode action")
                if let hourString = hour, let hourValue = Int(hourString) {
                    timeOutLength += hourValue * 3600
                }
                
                else {
                    print("Invalid hour value or nil.")
                }
                
                if let minuteString = minute, let minuteValue = Int(minuteString) {
                    timeOutLength += minuteValue * 60
                }else {
                    print("Invalid minute value or nil.")
                }
                
                scheduleBreak(timeOutLength: timeOutLength)
            }else{
                scheduleNotification()
            }
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
