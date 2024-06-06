//
//  OnboardingNavBarView.swift
//  Nix
//
//  Created by Grace Yang on 5/31/24.
//

import SwiftUI


struct OnboardingProgressBarView: View {
    
    var currentPage: Int
    
    var body: some View {
        HStack {
           Spacer()
           ForEach(0..<6) { 
               index in
               RoundedRectangle(cornerRadius: 2)
                   .frame(width: 50, height: 5)
                   .foregroundStyle(index < currentPage ? Color.babyBlue : Color.lightGray)
           }
           Spacer()
        }
        .padding(.top, 30)
    }
}

#Preview {
    OnboardingProgressBarView(currentPage: 2)
}
