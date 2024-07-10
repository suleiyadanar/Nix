//
//  OnboardingBackgroundView.swift
//  Nix
//
//  Created by Grace Yang on 5/31/24.
//

import SwiftUI

struct OnboardingBackgroundView: View {
    @State private var animateGradient: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.babyBlue, .lightYellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(animateGradient ? 35 : 0))
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }

            VStack {
                Spacer()
                Image("vector_group")
            }
        }
    }
}

#Preview {
    OnboardingBackgroundView()
}
