//
//  ChartReport.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 7/11/24.
//

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let chartReportDay = Self("ChartReportDay")
}

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let chartReportWeek = Self("ChartReportWeek")
}


struct ChartReportDay: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .chartReportDay
    let content: ([TimeInterval]) -> ChartReportDayView

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [TimeInterval] {
        let reportData = await data.flatMap { $0.activitySegments }
            .map { $0.totalActivityDuration / 60.0 }
                                          .reduce(into: [TimeInterval](), { $0.append($1) })
        return reportData
    }
}

struct ChartReportWeek: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .chartReportWeek
    let content: ([TimeInterval]) -> ChartReportWeekView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [TimeInterval] {
        let activityDurations = await data.flatMap { $0.activitySegments }
            .map { $0.totalActivityDuration / 3600 }
            .reduce(into: [TimeInterval](), { $0.append($1) })
        
        
        
        return activityDurations
    }
}

//struct ChartReport: DeviceActivityReportScene {
//    let context: DeviceActivityReport.Context = .chartReport
//    let content: (String) -> ChartReportView
//
//    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
//        let activityDurations = await data.flatMap { $0.activitySegments }
//                                          .map { $0.totalActivityDuration }
//                                          .reduce(into: [TimeInterval](), { $0.append($1) })
//        let activityDurationsString = activityDurations.map { String($0) }.joined(separator: ", ")
//        
//        return "Activity Durations: [\(activityDurationsString)]"
//    }
//}
