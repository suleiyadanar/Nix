// ScreenTimeView.swift
// Nix
//
// Created by Grace Yang on 6/14/24.
//

import SwiftUI
import DeviceActivity
import UIKit

struct ScreenTimeView: View {
    @State private var todayDay = Date() // Changed to @State

    @State private var today = Date() // Changed to @State
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    @State private var selectedTab = 0

    @State private var contextChartDay: DeviceActivityReport.Context = .init(rawValue: "ChartReportDay")
    @State private var contextChartWeek: DeviceActivityReport.Context = .init(rawValue: "ChartReportWeek")
    @State private var contextTotal: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    
    private var filterChartDay: DeviceActivityFilter {
        return DeviceActivityFilter(
            segment: .hourly(
                during: Calendar.current.dateInterval(of: .day, for: today)!
            ),
            users: .all,
            devices: .init([.iPhone, .iPad])
        )
    }
    
    private var weeklyFilter: DeviceActivityFilter {
        let calendar = Calendar.current
        
        // Calculate the start of the week 6 days before today
        guard let startOfWeek = calendar.date(byAdding: .day, value: -6, to: today) else {
            fatalError("Failed to calculate start of the week")
        }
        
        // Calculate the end of the week to today
        let endOfWeek = today
        
        // Set start of week to midnight
        let startOfDay = calendar.startOfDay(for: startOfWeek)
        
        // Print statements for debugging
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        print("Start of week: \(dateFormatter.string(from: startOfDay))")
        print("End of week: \(dateFormatter.string(from: endOfWeek))")
        
        // Determine devices based on the current device type
        let devices: Set<DeviceActivityData.Device.Model>
        if UIDevice.current.userInterfaceIdiom == .phone {
            devices = [.iPhone]
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            devices = [.iPad]
        } else {
            fatalError("Unknown device type")
        }
        
        // Create the filter with daily segment during the current week interval
        return DeviceActivityFilter(
            segment: .daily(during: DateInterval(start: startOfDay, end: endOfWeek)),
            users: .all,
            devices: .init(devices)
        )
    }
    
    private var filterTotal: DeviceActivityFilter {
        return DeviceActivityFilter(
            segment: .daily(
                during: Calendar.current.dateInterval(of: .day, for: today)!
            ),
            users: .all,
            devices: .init([.iPhone, .iPad])
        )
    }
    
  
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedTab = 0
                }) {
                    Text("Today")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .background(selectedTab == 0 ? Color.babyBlue : Color.clear)
                        .foregroundStyle(selectedTab == 0 ? Color.white : Color.black)
                        .cornerRadius(15)
                }
                Button(action: {
                    selectedTab = 1
                }) {
                    Text("Week")
                        .frame(maxWidth: .infinity,  maxHeight: 35)
                        .background(selectedTab == 1 ? Color.babyBlue : Color.clear)
                        .foregroundStyle(selectedTab == 1 ? Color.white : Color.black)
                        .cornerRadius(15)
                }
            }
            .padding(.bottom, 20)

            if selectedTab == 0 {
                VStack {
                    DeviceActivityReport(contextChartDay, filter: filterChartDay)
                    DeviceActivityReport(contextTotal, filter: filterTotal)
                }
            } else {
                VStack {
                    DeviceActivityReport(contextChartWeek, filter: weeklyFilter)
                  
                }
            }
        }
        .padding(.horizontal, 10)
       
    }
}
