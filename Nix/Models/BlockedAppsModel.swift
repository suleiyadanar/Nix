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
            let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")!

            do {
                let encodedData = try JSONEncoder().encode(self.activitySelection.applicationTokens)
                userDefaults.set(encodedData, forKey: "activitySelection")
                
               
            } catch {
                print("Error: \(error)")
            }
            
            objectWillChange.send()
        }
    }

    init() {
        self.activitySelection = FamilyActivitySelection()
    }
}


    

