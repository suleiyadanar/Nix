//
//  OnboardingNavBarView.swift
//  Nix
//
//  Created by Grace Yang on 5/31/24.
//

import SwiftUI


struct OnboardingProgressBarView: View {
    var currentPage: Int
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(0..<6) { index in
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 50, height: 5)
                    .foregroundStyle(index < currentPage-1 ? Color.babyBlue : Color.lightGray)
                    .overlay(
                        ZStack(alignment: .leading) {
                            if index == currentPage - 1 {
                                GeometryReader { geometry in
                                    let width = geometry.size.width
                                    LinearGradient(gradient: Gradient(colors: [ Color.babyBlue, Color.babyBlue.opacity(0.0)]),
                                                   startPoint: .leading,
                                                   endPoint: .trailing)
                                        .frame(width: isAnimating ? width : 0, height: geometry.size.height)
                                        .animation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false), value: isAnimating)
                                        .onAppear {
                                            isAnimating = true
                                        }
                                }
                            }
                        }
                    )
            }
            Spacer()
        }
        .padding(.top, 30)
    }
}



#Preview {
    OnboardingProgressBarView(currentPage: 2)
}
