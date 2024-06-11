//
//  PomodoroViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI

class PomodoroViewViewModel : NSObject,ObservableObject, UNUserNotificationCenterDelegate {
   
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    
    
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var isFinished: Bool = false
    
    override init() {
        super.init()
        self.authorizeNotification()
    }
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in }
        
        UNUserNotificationCenter.current().delegate = self
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            // Post a notification to notify the app about the notification tap
            NotificationCenter.default.post(name: NSNotification.Name("NotificationTapped"), object: nil)
            completionHandler()
        }
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)){
            isStarted = true
        }
        
        timerStringValue = "\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        
        totalSeconds = (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
    func stopTimer() {
        withAnimation {
            isStarted = false
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        
        timerStringValue = "\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        
        if seconds == 0 && minutes == 0 {
            isStarted = false
            print("Finished")
            isFinished = true
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Nix"
        content.subtitle = "Pomodoro Complete"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
        
    }
}
