//
//  TimeOutViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 6/23/24.
//

import SwiftUI

class TimeOutViewModel: NSObject,ObservableObject{
    
    @Published var timerStringValue: String = "00:00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false

    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var isFinished: Bool = false
    private var timer: Timer?

    @Published var timerCount: Int = 0
    override init() {
        super.init()
//        loadTimerData()
    }
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    func startTimer(total: Int) {
        print("startTimer")
        isStarted = true
        
        totalSeconds = total
        print(totalSeconds)
        staticTotalSeconds = totalSeconds
        addNewTimer = false
//        
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
//                   guard let self = self else { return }
//                   if self.totalSeconds > 0 {
//                       self.totalSeconds -= 1
//                       print("timer reducing -1")
//                   } else {
//                       print("timer invalidate")
//                       timer.invalidate()
//                       self.isStarted = false
//                   }
//               }
//        print("timer ended")
        
//        userDefaults?.set(totalSeconds, forKey: "totalSeconds")
//        userDefaults?.set(isStarted, forKey: "isStarted")
        
        
    }
    
    func updateTimer() {
        print("updating timer")
        totalSeconds -= 1
       
        if totalSeconds == 0 {
            isStarted = false
            print("Finished")
            isFinished = true
        }
       
    }
//    func saveTimerData() {
//        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
//        userDefaults?.set(totalSeconds, forKey: "totalSeconds")
//        userDefaults?.set(isStarted, forKey: "isStarted")
//
//        
//        // Add more properties as needed
//    }
//    func loadTimerData() {
//        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
//        totalSeconds = userDefaults?.integer(forKey: "totalSeconds") ?? 0
//        isStarted = userDefaults?.bool(forKey: "isStarted") ?? false
//        // Load more properties as needed
//    }
}
