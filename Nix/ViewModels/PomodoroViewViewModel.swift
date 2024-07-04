//
//  PomodoroViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import DeviceActivity

class PomodoroViewViewModel : NSObject,ObservableObject, UNUserNotificationCenterDelegate {
   
    @Published var item: RuleItem? = RuleItem(
            id: "pomodoro-7891-23459",
            title: "Pomodoro",
            startTime: Date().timeIntervalSince1970,
            endTime: Date().timeIntervalSince1970 + 901, // Example: 1 min from now
            fromDate: Date().timeIntervalSince1970,
            toDate: Date().timeIntervalSince1970 + 86400, // Example: 1 day from now
            selectedDays: [1, 2, 3, 4, 5], // Example: weekdays
            selectedApps: "com.example.app",
            selectedData: "",
            selectionType: "",
            mode: "pomodoro",
            unlock: "",
            delay: 5, // Example: 5 seconds
            timeOutLength: 0, // Example: 1 minute
            timeOutAllowed: 0, // Example: 3 timeouts allowed
            intentionalMinutes: 15, // Example: 15 minutes
            intentionalHours: 1,
            color: "swatch_lemon"// Example: 1 hour
    )

    @Published var showingAppGroup = false
    var selectedData = String()
    var selectionType = String()
    @Published var alertMessage = ""
    @Published var showAlert = false

    
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false

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
       
        scheduleBreak(timeOutLength: staticBreakMinutes * 60 + staticBreakSeconds)
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
        saveSchedule(minutes: staticMinutes, seconds: staticSeconds)
    }
    
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        
        timerStringValue = "\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        
        if seconds == 0 && minutes == 0 {
//            isStarted = false
            print("Finished")
            isFinished = true
            changeState()
        }
    }
    func saveSchedule(minutes: Int, seconds: Int) {
        if selectedData != "" {
            let activityName = DeviceActivityName(rawValue: "\(String(describing: item?.title))-\(String(describing: item?.mode))-\(String(describing: item?.intentionalHours))-\(String(describing: item?.intentionalMinutes))")
            
            
            
            let calendar = Calendar.current
            
            // Calculate intervalStart and intervalEnd based on startTime and endTime
//            let intervalStart = Date(timeIntervalSince1970: item?.startTime ?? Date().timeIntervalSince1970)
//            let intervalEnd = Date(timeIntervalSince1970: item?.endTime ?? (Date().timeIntervalSince1970 + Double(minutes)*60 + Double(seconds)))
//            
//            print("interval start", intervalStart)
//            print("interval end", intervalEnd)
//            
//            let center = DeviceActivityCenter()
//            let schedule = DeviceActivitySchedule(intervalStart: calendar.dateComponents([.hour, .minute], from: intervalStart),
//                                                  intervalEnd: calendar.dateComponents([.hour, .minute], from: intervalEnd),
//                                                  repeats: false)
            let intervalStart = Date()
               let intervalEnd = intervalStart.addingTimeInterval(Double(minutes * 60 + seconds))

               print("interval start", intervalStart)
               print("interval end", intervalEnd)

               let center = DeviceActivityCenter()
               let schedule = DeviceActivitySchedule(
                   intervalStart: calendar.dateComponents([.hour, .minute], from: intervalStart),
                   intervalEnd: calendar.dateComponents([.hour, .minute], from: intervalEnd),
                   repeats: false
               )
               
            do {
                try center.startMonitoring(activityName, during: schedule)
                print("evnts fetch", center.events(for:activityName))
                print("this is the activity running", center.activities)
                
                print("monitoring")
            } catch let error {
                print("error \(error)")
            }
            
            if canSave {
                print("can save")
                self.save { result in
                                    switch result {
                                    case .success(_):
                                        print("Save successful")
                                    case .failure(let error):
                                        print("Save failed: \(error)")
                                    }
                                }
                //            newItemPresented = false
            } else {
                showAlert = true
            }
        }
    }
    func stopSchedule() {
        if selectedData != "" {
            let activityName = DeviceActivityName(rawValue: "\(String(describing: item?.title))-\(String(describing: item?.mode))-\(String(describing: item?.intentionalHours))-\(String(describing: item?.intentionalMinutes))")
            let center = DeviceActivityCenter()
            print("stop schedule:", center.activities)
            center.stopMonitoring([activityName,DeviceActivityName(rawValue:"breakTime")])
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
            saveSchedule(minutes: staticMinutes, seconds: staticSeconds)
        } else {
            withAnimation {
                isBreak = true
                breakMinutes = staticBreakMinutes
                breakSeconds = staticBreakSeconds
                totalSeconds = (staticBreakMinutes * 60) + staticBreakSeconds

                timerStringValue = "\(staticBreakMinutes >= 10 ? "\(staticBreakMinutes)":"0\(staticBreakMinutes)"):\(staticBreakSeconds >= 10 ? "\(staticBreakSeconds)":"0\(staticBreakSeconds)")"
            }
            startBreak()
         
        }
    }
    
    func pauseTimer() {
        isStarted = false
    }
    func stopTimer() {
        if !isBreak {
            withAnimation {
                isStarted = false
                minutes = staticMinutes
                seconds = staticSeconds
                progress = 1
            }
            totalSeconds = (minutes * 60) + seconds
            staticTotalSeconds = totalSeconds
            timerStringValue = "\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        }else{
            withAnimation {
                isStarted = false
                minutes = staticBreakMinutes
                seconds = staticBreakSeconds
                progress = 1
            }
            totalSeconds = (staticBreakMinutes * 60) + staticBreakSeconds
            staticTotalSeconds = totalSeconds
            timerStringValue = "\(staticBreakMinutes >= 10 ? "\(staticBreakMinutes)":"0\(staticBreakMinutes)"):\(staticBreakSeconds >= 10 ? "\(staticBreakSeconds)":"0\(staticBreakSeconds)")"
        }
        stopSchedule()
        
    }
    
    private func scheduleBreak(timeOutLength: Int) {
        
        let center = DeviceActivityCenter()
        let activityName = DeviceActivityName(rawValue: "breakTime")
        let now = Date()
        let start = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
        let end = Calendar.current.dateComponents([.hour, .minute, .second], from: now.advanced(by: Double(timeOutLength < 15 ? 15 : timeOutLength) * 60))

        let schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: false,
            warningTime: timeOutLength < 15 ? DateComponents(minute: 15 - timeOutLength) : nil
        )

        do {
            try center.startMonitoring(activityName, during: schedule)
            print("Break happening")
        } catch let error {
            print("Error starting monitoring: \(error)")
        }
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
//    func updateStartTime() {
//            item?.startTime = Date().timeIntervalSince1970
//        }
    
    var canSave : Bool {
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

        if let selectData = userDefaults?.object(forKey: "selectedApps") as? Data {
            selectedData = String(decoding: selectData, as: UTF8.self)
        }
        
        let calendar = Calendar.current

        var intervalStart = calendar.dateComponents([.hour, .minute], from: Date().addingTimeInterval(item?.startTime ?? Date().timeIntervalSince1970))
        
        var intervalEnd = calendar.dateComponents([.hour, .minute], from: Date().addingTimeInterval(item?.endTime ?? Date().timeIntervalSince1970))
        
        let timeInterval = Date().addingTimeInterval(item?.endTime ?? Date().timeIntervalSince1970 ).timeIntervalSince(Date().addingTimeInterval(item?.startTime ?? Date().timeIntervalSince1970))
        
        let minimumInterval: TimeInterval = 15 * 60 // 15 minutes in seconds
        
        print(timeInterval)
        print(minimumInterval)
        guard timeInterval >= minimumInterval else {
            print("Got here")
            alertMessage += "The session needs to be at least 15 minutes long."
            return false
        }
    
        return true
    }
    func save(completion: @escaping (Result<Int, Error>) -> Void) {
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        
        let userDocument = db.collection("users").document(uId)
        let rulesCollection = userDocument.collection("rules")
        let documentID = "pomodoro-7891-23459" // The ID you want to check and possibly update
        
        let data: [String: Any] = [
            "id": documentID,
            "title": item?.title ?? "",
            "startTime": item?.startTime ?? 0,
            "endTime": item?.endTime ?? 0,
            "fromDate": item?.fromDate ?? 0,
            "toDate": item?.toDate ?? 0,
            "selectedDays": Array(item?.selectedDays ?? []).sorted(),
            "selectedApps": item?.selectedApps ?? "",
            "selectedData": item?.selectedData ?? selectedData,
            "selectionType": selectionType,
            "mode": item?.mode ?? "",
            "unlock": item?.unlock ?? "",
            "delay": item?.delay ?? 0,
            "timeOutLength": item?.timeOutLength ?? 0,
            "timeOutAllowed": item?.timeOutAllowed ?? 0,
            "intentionalMinutes": item?.intentionalMinutes ?? 0,
            "intentionalHours": item?.intentionalHours ?? 0
        ]
        
        // Check if document exists
        rulesCollection.document(documentID).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                // Update existing document
                rulesCollection.document(documentID).updateData(data) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(1))
                    }
                }
            } else {
                // Create new document
                item?.selectedData = selectedData
                let newRule = item
                
                // Save new model
                rulesCollection.document(documentID).setData(newRule?.asDictionary() ?? [:]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(0))
                    }
                }
            }
        }
    }

}
