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
  
    override func intervalDidStart(for activity: DeviceActivityName) {
        
        super.intervalDidStart(for: activity)
        
        // connect to the app groups
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
        
        do {
            // get selected app tokens from app groups
            if let appData = userDefaults?.object(forKey: "applications") as? Data {
                let decodedApplicationTokens = try JSONDecoder().decode([ApplicationToken].self, from: appData)
                
                //
                store.shield.applications = decodedApplicationTokens.isEmpty ? nil : Set(decodedApplicationTokens)
                
                print("\(decodedApplicationTokens)")
                print("Got Here 1")
            }
            
            // get selected website tokens from app groups
            if let webData = userDefaults?.object(forKey: "websites") as? Data {
                let decodedWebsiteTokens = try JSONDecoder().decode([WebDomainToken].self, from: webData)
                
                //
                store.shield.webDomains = decodedWebsiteTokens.isEmpty ? nil : Set(decodedWebsiteTokens)
                
                print("\(decodedWebsiteTokens)")
                print("Got Here 2")
            }
        }catch {
            print("Error: \(error)")
        }
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.shield.applications = nil
    }

    override func eventDidReachThreshold(_ event:DeviceActivityEvent.Name,activity:DeviceActivityName){
        super.eventDidReachThreshold(event, activity: activity)
    }
}
