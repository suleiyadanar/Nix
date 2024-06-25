//
//  NixApp.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/15/24.
//

import SwiftUI
import FirebaseCore
import FamilyControls
import DeviceActivity


private let thisWeek = DateInterval(start: Date(), end: Date())

@main struct NixApp: App {
    
    var userSettings = UserSettings()
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    init() {
        FirebaseApp.configure()
    }
    let center = AuthorizationCenter.shared
    @StateObject var pomodoroModel: PomodoroViewViewModel = .init()
    @StateObject var timeoutModel: TimeOutViewModel = .init()
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp: Date = Date()
    var body: some Scene {
        WindowGroup {

            MainView()
                .environmentObject(pomodoroModel)
                .environmentObject(userSettings)
                .environmentObject(timeoutModel)
                .onAppear {
                    Task {
                        do {
                            try await center.requestAuthorization(for: .individual)
                        } catch {
                            print("Error")
                        }
                    }
                }

        }.onChange(of: phase) {
            
            if pomodoroModel.isStarted {
                if phase == .background {
                    lastActiveTimeStamp = Date()
                }
                if phase == .active {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                    }else{
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                  
                }
            }
           
//            var totalSeconds =  userDefaults?.integer(forKey: "totalSeconds")
//
//            if totalSeconds ?? 0 > 0 {
//                if phase == .background {
//                    lastActiveTimeStamp = Date()
//                    userDefaults?.set(lastActiveTimeStamp, forKey: "lastActiveTimer")
//
//                    print("got here bg")
//                }
//                if phase == .active {
//                    print("got here active")
//                    totalSeconds =  userDefaults?.integer(forKey: "totalSeconds")
//
//                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
//                    if totalSeconds ?? 0 - Int(currentTimeStampDiff) <= 0 {
//                        userDefaults?.removeObject(forKey: "totalSeconds")
//                    }else{
//                        totalSeconds! -= Int(currentTimeStampDiff)
//                        userDefaults?.set(totalSeconds, forKey: "totalSeconds")
//                    }
//                }
//                
//            }
            
//            print("timeoutModel started is \(timeoutModel.isStarted)")
//            if timeoutModel.isStarted {
//                print("got here is starting")
//                if phase == .background {
//                    lastActiveTimeStamp = Date()
//                    print("got here bg")
//                }
//                if phase == .active {
//                    print("got here active")
//                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
//
//                    if timeoutModel.totalSeconds  - Int(currentTimeStampDiff) <= 0 {
//                        timeoutModel.isStarted = false
//                        timeoutModel.totalSeconds = 0
//                        timeoutModel.isFinished = true
//                    } else {
//                        timeoutModel.totalSeconds -= Int(currentTimeStampDiff)
//
//                    }
//                    print(timeoutModel.totalSeconds)
//                
//                }
//               
//              
//
//            }

                // sorry we can change this after i figure out how to change the placeholder text color for the
                // text input boxes bc it keeps changing when its light/dark mode and becoming invisible in dark mode
                

        }
    }
}
