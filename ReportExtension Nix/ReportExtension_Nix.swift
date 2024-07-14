//
//  ReportExtension_Nix.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/10/24.
//

import DeviceActivity
import SwiftUI

@main
struct ReportExtension_Nix: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        ChartReportDay { reportData in
            ChartReportDayView(reportData: reportData)
        }
        
        ChartReportWeek { reportData in
            ChartReportWeekView(weeklyReportData: reportData)
        }
        
        RemainingScreenTimeReport { remainingScreenTime in
            RemainingScreenTimeView(remainingScreenTime: remainingScreenTime)
        }
        
       PercentScreenTimeReport { percentScreenTime in
            PercentScreenTimeView(percentScreenTime: percentScreenTime)
        }
        
        TotalScreenTimeReport { totalScreenTime in
            TotalScreenTimeView(totalScreenTime: totalScreenTime)
        }
        
        TotalActivityReport { configuration in
            TotalActivityView(configuration: configuration)
        }
        // Add more reports here...
    }
}
