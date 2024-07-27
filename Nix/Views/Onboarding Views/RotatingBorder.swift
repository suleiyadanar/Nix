//
//  RotatingView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/23/24.
//

import SwiftUI

struct RotatingBorder: ViewModifier {
    @State private var rotation: Double = 0
    var props: Properties

    func body(content: Content) -> some View {
        ZStack {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: props.round.sheet)
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
    func rotatingBorder(props: Properties) -> some View {
        self.modifier(RotatingBorder(props:props))
    }
}
