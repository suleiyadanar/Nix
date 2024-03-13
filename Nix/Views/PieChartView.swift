//
//  PieChartView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 3/10/24.
//

import SwiftUI
import DeviceActivity

struct PieChartReport: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .pieChart
    let content: (PieChartView.Configuration) -> PieChartView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> PieChartView.Configuration {
        var totalUsageByCategory: [TimeInterval]
        print(data)
        totalUsageByCategory = []
        return PieChartView.Configuration(totalUsageByCategory: totalUsageByCategory)
    }
    
    

}

struct PieChartView: View {
    struct Configuration {
        let totalUsageByCategory: [TimeInterval]
    }
    
    let configuration: Configuration
    
    var body: some View {
        // A complex view that renders a bar graph based on Aniyah’s usage per category.
        PomodoroView()
//        PieChart(usage: configuration.totalUsageByCategory)
    }
}



