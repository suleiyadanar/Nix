//
//  RemainingScreenTimeView.swift
//  ReportExtension Nix
//
//  Created by Su Lei Yadanar on 7/10/24.
//

import SwiftUI

struct RemainingScreenTimeView: View {
    let remainingScreenTime: String
    
    var body: some View {
        let components = remainingScreenTime.components(separatedBy: ":\n")
        let header = components.first ?? ""
        let timeString = components.count > 1 ? components[1] : ""
        
            
            GeometryReader { geometry in
                let widthToCalculate = min(geometry.size.width, geometry.size.height)
                let fontSize = self.fontSize(for: widthToCalculate)
                withAnimation(.easeInOut(duration: 1.5)){
                VStack(alignment:.leading,spacing:0) {
                    Text(header)
                        .foregroundColor(header == "Exceeding" ? .red : .babyBlue)
                        .font(.custom("Nunito-Medium", size: fontSize))
                    
                    Text(timeString)
                        .foregroundColor(.babyBlue)
                        .font(.custom("Nunito-Medium", size: fontSize))
                }
            }
        }
    }
    
    private func fontSize(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<700:
            return 18
        case 700..<1000:
            return 22
        case 1000...:
            return 28
        default:
            return 20
        }
    }
}


//#Preview {
//    RemainingScreenTimeView()
//}
