//
//  AppActivityItemView.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/11/24.
//

import SwiftUI
import ManagedSettings
import FamilyControls

struct TotalActivityItemView: View {
    let totalActivity: DeviceActivityModel

    func durationFormatter(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        if let formattedString = formatter.string(from: duration) {
                return formattedString.replacingOccurrences(of: ",", with: "")
        } else {
                return "No data"
        }
    }

    var body: some View {
            HStack {
                if let token = totalActivity.token {
                    Label(token).labelStyle(.iconOnly)
                }
                Text("\(totalActivity.appName)")
                Spacer()
                Text("\(durationFormatter(duration: totalActivity.duration))")
            
        }.frame(maxWidth:.infinity)
    }
}
