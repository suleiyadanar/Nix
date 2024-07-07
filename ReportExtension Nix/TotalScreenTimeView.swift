//
//  TotalActivityView.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 3/10/24.
//

import SwiftUI

struct TotalScreenTimeView: View {
    let totalScreenTime: String
    
    var body: some View {
        Text(totalScreenTime)
            .foregroundColor(.babyBlue) // Change text color to blue
                      .font(.largeTitle)
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    TotalScreenTimeView(totalScreenTime: "1h 23m")
}
