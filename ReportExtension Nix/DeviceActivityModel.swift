//
//  DeviceActivityModel.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/10/24.
//

import Foundation
import ManagedSettings

struct DeviceActivityModel {
    let id : String
    let appName : String
    let token : ApplicationToken?
    let duration : TimeInterval
    let numberOfPickups: Int
    
    func formattedDuration() -> String {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .short
            formatter.allowedUnits = [.hour, .minute]
            formatter.zeroFormattingBehavior = .pad
            return formatter.string(from: duration) ?? "N/A"
        }
        
        // Function to return a string representation of the model
        func description() -> String {
            return "ID: \(id), App Name: \(appName), Duration: \(formattedDuration()), Number of Pickups: \(numberOfPickups)"
        }
}
