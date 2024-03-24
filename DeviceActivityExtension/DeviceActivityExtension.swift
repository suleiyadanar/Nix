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
//        
//        let model = BlockedAppsModel()
//        let applications = model.activitySelection.applicationTokens
//        
//        NSLog("\(applications)")
//        store.shield.applications = applications
        
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
        do {
            if let data = userDefaults?.object(forKey: "activitySelection") as? Data {
                let decodedActivityTokens = try JSONDecoder().decode([ApplicationToken].self, from: data)
                store.shield.applications = decodedActivityTokens.isEmpty ? nil : Set(decodedActivityTokens)
                print("\(decodedActivityTokens)")
                print("Got Here")
            }
        }catch {
            print("Error: \(error)")
        }
//        let blockedApps = UserDefaults(suiteName: "group.nix.Nix.DeviceActivityExtension")
//        let test = blockedApps?.object(forKey: "appsModel") as? String
//        let testURL = URL(fileURLWithPath: test!)
        
//        do {
//            // Read the contents of the file at the URL
//            let data = try Data(contentsOf: testURL)
//            
//            // Decode the data into a BlockedAppsModel instance
//            let decoder = JSONDecoder()
//            let blockedAppsModel = try decoder.decode(BlockedAppsModel.self, from: data)
//            
//            let applications  = blockedAppsModel.activitySelection.applicationTokens
////            let model = BlockedAppsModel()
//            
//            
//            store.shield.applications = applications
//            // Access the properties of the decoded object
//            print("activitySelection: \(blockedAppsModel.activitySelection)")
//        } catch {
//            // Handle error
//            print("Error reading or decoding contents from URL: \(error)")
//        }
        
        
    }

    

    override func intervalDidEnd(for activity: DeviceActivityName) {

        super.intervalDidEnd(for: activity)
        store.shield.applications = nil

    }

    

    override func eventDidReachThreshold(_ event:DeviceActivityEvent.Name,activity:DeviceActivityName){

        

        super.eventDidReachThreshold(event, activity: activity)

    }

    

}
