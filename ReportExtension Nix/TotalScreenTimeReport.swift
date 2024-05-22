//
//  TotalScreenTimeReport.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/10/24.
//

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let totalScreenTime = Self("Total ScreenTime")
}

struct TotalScreenTimeReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalScreenTime
    
    // Define the custom configuration and the resulting view for this report.
    let content: (String) -> TotalScreenTimeView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
//        // Reformat the data into a configuration that can be used to create
//        // the report's view.
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        
        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
                
        // Check if totalActivityDuration is greater than a day
                if totalActivityDuration > 86400 { // 86400 seconds = 1 day
                    // Divide totalActivityDuration by 7
                    let averageDuration = totalActivityDuration / 7
                    return (formatter.string(from: averageDuration) ?? "No activity data")
                } else {
                    // Otherwise, return totalActivityDuration as it is
                    return (formatter.string(from: totalActivityDuration) ?? "No activity data")
                }
    }
}
