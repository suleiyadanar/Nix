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

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let remainingScreenTime = Self("Remaining ScreenTime")
}

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let percentScreenTime = Self("Percent ScreenTime")
}

struct RemainingScreenTimeReport: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .remainingScreenTime
    let content: (String) -> RemainingScreenTimeView

    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
//        userDefaults?.set(200, forKey:"maxUnProdST")

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll

        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
        
        // Convert total activity duration to minutes
        let totalActivityDurationInMinutes = Int(totalActivityDuration / 60)
//        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
//        userDefaults?.set(500, forKey: "maxUnProdST")
        let maxUnProdST = userDefaults?.integer(forKey: "maxUnProdST")

        let remainingTime = (maxUnProdST ?? 0) - totalActivityDurationInMinutes

        // Determine if the time is remaining or exceeding
        let timeString: String
        if remainingTime >= 0 {
            let hours = Int(remainingTime / 60)
            let minutes = Int(remainingTime) % 60
            if hours > 0 {
                timeString = String(format: "Remaining\n%02d hr %02d min", hours, minutes)
            } else {
                timeString = String(format: "Remaining\n%02d min", minutes)
            }
        } else {
            let exceededTime = abs(remainingTime)
            let hours = Int(exceededTime / 60)
            let minutes = Int(exceededTime) % 60
            if hours > 0 {
                timeString = String(format: "Exceeding\n%02d hr %02d min", hours, minutes)
            } else {
                timeString = String(format: "Exceeding\n%02d min", minutes)
            }
        }
        print(timeString)
        return String(timeString)
    }
}

struct PercentScreenTimeReport: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .percentScreenTime
    let content: (String) -> PercentScreenTimeView

    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
//        userDefaults?.set(200, forKey:"maxUnProdST")

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll

        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
        
        // Convert total activity duration to minutes
        let totalActivityDurationInMinutes = Int(totalActivityDuration / 60)
//        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
//        userDefaults?.set(500, forKey: "maxUnProdST")
        let maxUnProdST = userDefaults?.integer(forKey: "maxUnProdST")

//        let percentTime = ((totalActivityDurationInMinutes - (maxUnProdST ?? 0)) / totalActivityDurationInMinutes) * 100
        let percentTime: Double
        if totalActivityDurationInMinutes == 0 {
            percentTime = 0
        }
        else if maxUnProdST == totalActivityDurationInMinutes {
            percentTime = 100
        }
        else if let maxUnProdST = maxUnProdST, maxUnProdST != 0 {
            percentTime =  ((Double(maxUnProdST)-Double(totalActivityDurationInMinutes)) / Double(maxUnProdST)) * 100
        } else {
            percentTime = 100
        }
        
        // Determine if the time is remaining or exceeding
        var resultString: String
        if percentTime == 100 {
            resultString = "100%"
        }else if percentTime == 0{
            resultString = "0%"
        }else if percentTime > 0{
            resultString = String(format: "%.1f%%", 100-percentTime)
        }else{
            resultString = "100%"
        }
        
        return resultString
    }
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
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .pad
        
        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
        let formattedString = formatter.string(from: totalActivityDuration) ?? "No activity data"


        let formattedWithNewline = formattedString.replacingOccurrences(of: ", ", with: "\n")

        return formattedWithNewline
    }
}
