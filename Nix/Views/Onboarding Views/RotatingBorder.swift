//
//  RotatingView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/23/24.
//

import SwiftUI

struct RotatingBorder: ViewModifier {
    @State private var rotation: Double = 0

    func body(content: Content) -> some View {
        ZStack {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.sky.opacity(0.4), .babyBlue.opacity(0.4), .sky.opacity(0.4)]),
                                center: .center,
                                startAngle: .degrees(rotation),
                                endAngle: .degrees(rotation + 360)
                            ),
                            lineWidth: 4
                        )
                )
                .onAppear {
                    withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
        }
    }
}
extension View {
    func rotatingBorder() -> some View {
        self.modifier(RotatingBorder())
    }
}
