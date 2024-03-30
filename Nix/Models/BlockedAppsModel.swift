//
//  BlockedAppsModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 3/16/24.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

class BlockedAppsModel: ObservableObject {
    @Published var activitySelection: FamilyActivitySelection {
        didSet {
            // connect to the app groups
            let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")!
           
            do {
                let selectedApps = try
                JSONEncoder().encode(self.activitySelection)
                // encode app tokens
                let encodedApps = try JSONEncoder().encode(self.activitySelection.applicationTokens)
                // encode web tokens
                let encodedWebsites = try JSONEncoder().encode(self.activitySelection.webDomainTokens)
                // save selection
                userDefaults.set(selectedApps, forKey: "selectedApps")
                // save app tokens
                userDefaults.set(encodedApps, forKey: "applications")
                // save web tokens
                userDefaults.set(encodedWebsites, forKey: "websites")
            } catch {
                print("Error: \(error)")
            }
            objectWillChange.send()
        }
    }

    init() {
        self.activitySelection = FamilyActivitySelection(includeEntireCategory: true)
    }
}


    

