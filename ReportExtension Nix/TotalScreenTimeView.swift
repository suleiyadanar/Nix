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
        withAnimation(.easeInOut(duration: 0.5)){
            GeometryReader { geometry in
                let widthToCalculate = min(geometry.size.width, geometry.size.height)
                let fontSize = self.fontSize(for: widthToCalculate)
                
                Text(totalScreenTime)
                    .foregroundColor(.babyBlue)
                    .font(.custom("Nunito-Regular", size: fontSize))
                    .padding(0)
            }
        }
    }

    private func fontSize(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<100: // Smaller iPhone sizes
            return 35
        case 100..<250: // Smaller iPhone sizes
            return 60
        case 250..<405: // Smaller iPhone sizes
            return 75
        default:
            return 35
        }
    }
}



// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    TotalScreenTimeView(totalScreenTime: "1h 23m")
}
