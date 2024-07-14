//
//  PercentScreenTimeView.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 7/10/24.
//

import SwiftUI

struct PercentScreenTimeView: View {
    
    let percentScreenTime: String
    
    var body: some View {
        withAnimation(.easeInOut(duration: 0.5)){
            GeometryReader { geometry in
                let widthToCalculate = min(geometry.size.width, geometry.size.height)
                let fontSize = self.fontSize(for: widthToCalculate)
                
                Text(percentScreenTime)
                    .foregroundColor(.babyBlue)
                    .font(.custom("Nunito-SemiBold", size: fontSize))
            }
        }
    }
    
    private func fontSize(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<700:
            return 23
        case 700..<1000:
            return 26
        case 1000...:
            return 35
        default:
            return 23
        }
    }
}

//#Preview {
//    PercentScreenTimeView()
//}
