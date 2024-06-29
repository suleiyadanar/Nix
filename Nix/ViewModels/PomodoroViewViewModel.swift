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
    @Published var isPaused: Bool = false

    @Published var addNewTimer: Bool = false

    @Published var isBreak : Bool = false
    @Published var pauseBreak: Bool = false
    
    @Published var staticMinutes: Int = 25
    @Published var staticSeconds: Int = 0
    @Published var minutes: Int = 25
    @Published var seconds: Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var staticBreakMinutes: Int = 5
    @Published var staticBreakSeconds: Int = 0
    @Published var breakMinutes: Int = 5
    @Published var breakSeconds: Int = 0
    
//    @Published var totalBreakSeconds: Int = 0
//    @Published var staticTotalBreakSeconds: Int = 0
//    
    @Published var isFinished: Bool = false
    
    override init() {
        super.init()
        self.authorizeNotification()
        timerStringValue = "\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
                
        totalSeconds = (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        
//        totalBreakSeconds = (breakMinutes * 60) + seconds
//        staticTotalBreakSeconds = totalBreakSeconds

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
    func startBreak () {
        withAnimation(.easeInOut(duration: 0.25)){
            isBreak = true
            isStarted = true
        }
        timerStringValue = "\(breakMinutes >= 10 ? "\(breakMinutes)":"0\(breakMinutes)"):\(breakSeconds >= 10 ? "\(breakSeconds)":"0\(breakSeconds)")"
        
        totalSeconds = (breakMinutes * 60) + breakSeconds
        staticTotalSeconds = totalSeconds
        addNotification()

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
    
    func changeState() {
        if isBreak {
            withAnimation  {
                isBreak = false
                minutes = staticMinutes
                seconds = staticSeconds
                totalSeconds = (staticMinutes * 60) + staticSeconds
                timerStringValue = "\(staticMinutes >= 10 ? "\(staticMinutes)":"0\(staticMinutes)"):\(staticSeconds >= 10 ? "\(staticSeconds)":"0\(staticSeconds)")"
//                staticTotalSeconds = totalSeconds
            }
         
        } else {
            withAnimation {
                isBreak = true
                breakMinutes = staticBreakMinutes
                breakSeconds = staticBreakSeconds
                totalSeconds = (staticBreakMinutes * 60) + staticBreakSeconds

                timerStringValue = "\(staticBreakMinutes >= 10 ? "\(staticBreakMinutes)":"0\(staticBreakMinutes)"):\(staticBreakSeconds >= 10 ? "\(staticBreakSeconds)":"0\(staticBreakSeconds)")"
            }
         
        }
    }
    
    func pauseTimer() {
        isStarted = false
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
    
    func saveSettings() {
          
          minutes = staticMinutes
          seconds = staticSeconds
          
          breakMinutes = staticBreakMinutes
          breakSeconds = staticBreakSeconds
          
          timerStringValue = "\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
          
          totalSeconds = (minutes * 60) + seconds
          
//          totalBreakSeconds = (breakMinutes * 60) + seconds
          
          staticTotalSeconds = totalSeconds
//          staticTotalBreakSeconds = totalBreakSeconds
          addNewTimer = false
      }
    
   
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Nix"
        if (isBreak) {
            content.subtitle = "Break End"
        }else{
            content.subtitle = "Pomodoro Complete"
        }
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
        
    }
}
