//
//  TotalActivityReport.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/10/24.
//

import DeviceActivity
import ManagedSettings
import SwiftUI

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let totalActivity = Self("Total Activity")
}

struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (TotalActivityView.Configuration) -> TotalActivityView
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> TotalActivityView.Configuration {
        var res = ""
                var list: [DeviceActivityModel] = []
                for await d in data {
                            res += d.user.appleID!.debugDescription
                            res += d.lastUpdatedDate.description
                            for await a in d.activitySegments{
                                res += a.totalActivityDuration.formatted()
                                for await c in a.categories {
        //                            cat += (c.category.localizedDisplayName ?? "nil") + ","
                                    for await ap in c.applications {
                                        let appName = (ap.application.localizedDisplayName ?? "nil")
                                        let bundle = (ap.application.bundleIdentifier ?? "nil")
                                        let token = (ap.application.token ?? nil)
                                        let duration = ap.totalActivityDuration
                                        let numberOfPickups = ap.numberOfPickups
        
                //                        let app = AppDeviceActivity(id: bundle, displayName: appName, duration: duration, numberOfPickups: numberOfPickups)
                                        let app = DeviceActivityModel(id: bundle, appName: appName, token: token, duration: duration, numberOfPickups: numberOfPickups)
                                        list.append(app)
                                    }
                                }
                            }
                        }
                var longString = ""
                for activity in list {
                    longString += activity.description()
                }
        return TotalActivityView.Configuration(totalActivity: list)
    }
}
