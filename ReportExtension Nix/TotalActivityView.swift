//
//  TotalActivityView.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/10/24.
//

import SwiftUI
import FamilyControls

struct TotalActivityView: View {
    struct Configuration {
        let totalActivity: [DeviceActivityModel]
    }
    let configuration: Configuration
    
    var sortedTotalActivity: [DeviceActivityModel] {
        return configuration.totalActivity.sorted(by: { $0.duration > $1.duration })
    }
    
    var body: some View {
        ScrollView{
            VStack (alignment: .leading) {
                ForEach(sortedTotalActivity.indices, id: \.self) { index in
                    TotalActivityItemView(totalActivity: sortedTotalActivity[index])
                }
            }
        }.frame(maxWidth:.infinity)
    }
}


