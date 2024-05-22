//
//  AppActivityItemView.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/11/24.
//

import SwiftUI
import ManagedSettings

struct TotalActivityItemView: View {
    
    let totalActivity: DeviceActivityModel

    func durationFormatter (duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute,.second ]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        
        return formatter.string(from: duration) ?? "No data"
    }
    var body: some View {
        VStack {
            HStack {
                if let token = totalActivity.token {
                    Label(token).labelStyle(.iconOnly)
                }
                Text("\(totalActivity.appName)")
                Text("\(durationFormatter(duration: totalActivity.duration))")
            }
            
        }
    }
}

