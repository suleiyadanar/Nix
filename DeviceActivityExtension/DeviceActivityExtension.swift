//
//  CallDirectoryHandler.swift
//  MyDeviceActivityMonitor
//
//  Created by Su Lei Yadanar on 3/12/24.
//

import Foundation
import DeviceActivity
import ManagedSettings

class MyDeviceActivityMonitor: DeviceActivityMonitor{

    let store = ManagedSettingsStore()
    // connect to the app groups

    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    override func intervalDidStart(for activity: DeviceActivityName) {
        
        super.intervalDidStart(for: activity)
        
        
        do {
            // get selected app tokens from app groups
            if let appData = userDefaults?.object(forKey: "applications") as? Data {
                let decodedApplicationTokens = try JSONDecoder().decode([ApplicationToken].self, from: appData)
                
                //
                if activity.rawValue == "breakTime" {
                    store.shield.applications = nil
                }else{
                    store.shield.applications = decodedApplicationTokens.isEmpty ? nil : Set(decodedApplicationTokens)
                }
                
//                print("\(decodedApplicationTokens)")
                print("Got Here 1")
            }
            
            // get selected website tokens from app groups
            if let webData = userDefaults?.object(forKey: "websites") as? Data {
                let decodedWebsiteTokens = try JSONDecoder().decode([WebDomainToken].self, from: webData)
                
                //
                if activity.rawValue == "breakTime" {
                    store.shield.webDomains = nil
                } else{
                    store.shield.webDomains = decodedWebsiteTokens.isEmpty ? nil : Set(decodedWebsiteTokens)

                }
                
//                print("\(decodedWebsiteTokens)")
                print("Got Here 2")
            }
            
            if activity.rawValue != "breakTime" {
                userDefaults?.set(activity.rawValue, forKey: "activeApp")
            }
            print("setting active app name")
        }catch {
            print("Error: \(error)")
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
//        if activity.rawValue == "breakTime" {
//
//            do {
//                if let appData = userDefaults?.object(forKey: "applications") as? Data {
//                    let decodedApplicationTokens = try JSONDecoder().decode([ApplicationToken].self, from: appData)
//                    store.shield.applications = decodedApplicationTokens.isEmpty ? nil : Set(decodedApplicationTokens)
//                }
//            }catch {
//                print("Error: \(error)")
//            }
//
//
//        }
        store.shield.applications = nil
    }

//    override func intervalWillStartWarning(for activity: DeviceActivityName) {
//            // Handle the warning that the interval is about to start
//            print("Activity interval will start in 5 minutes.")
//        }
//
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
            super.intervalWillEndWarning(for: activity)
            // Unshield apps after one minute
            let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
            
            do {
                // get selected app tokens from app groups
                if let appData = userDefaults?.object(forKey: "applications") as? Data {
                    let decodedApplicationTokens = try JSONDecoder().decode([ApplicationToken].self, from: appData)
                    
                    store.shield.applications = decodedApplicationTokens.isEmpty ? nil : Set(decodedApplicationTokens)
//                    let timeout = userDefaults?.object(forKey: "timeout")as! Double
//                    print("Unshielding apps for \(timeout) minute.")
                    
                    
//
                    // Reapply the shield after one minute
//                    DispatchQueue.main.asyncAfter(deadline: .now() + (timeout  * 60)) {
//                        self.store.shield.applications = Set(decodedApplicationTokens)
//                        print("Reapplied shield.")
//                    }
                   
                }
            } catch {
                print("Error: \(error)")
            }
        }
    override func eventDidReachThreshold(_ event:DeviceActivityEvent.Name,activity:DeviceActivityName){
        super.eventDidReachThreshold(event, activity: activity)
    }
}



