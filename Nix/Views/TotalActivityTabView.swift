//
//  TotalActivityView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 3/11/24.
//

import SwiftUI
import DeviceActivity

struct TotalActivityTabView: View {
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
        during: Calendar.current.dateInterval(
        of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    var body: some View {
        DeviceActivityReport(context, filter: filter)
    }
}

#Preview {
    TotalActivityTabView()
}
