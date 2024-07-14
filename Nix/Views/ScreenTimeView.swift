//
//  ScreenTimeView.swift
//  Nix
//
//  Created by Grace Yang on 6/14/24.
//

import SwiftUI
import DeviceActivity

struct ScreenTimeView: View {
    @State private var contextDay: DeviceActivityReport.Context = .init(rawValue: "ChartReportDay")
    
    @State private var filterDay = DeviceActivityFilter(
        segment: .daily(
        during: Calendar.current.dateInterval(
        of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    
    
    var body: some View {
        Text("Screen Time View")
    }
}

#Preview {
    ScreenTimeView()
}
