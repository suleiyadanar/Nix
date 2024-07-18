//
//  SaveButtonView.swift
//  Nix
//
//  Created by Grace Yang on 7/18/24.
//

import SwiftUI

struct SaveButtonView: View {
    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lemon)
                .offset(x: 3, y: 5)
            
            // Button layer with rotating gradient border
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lav.opacity(0.9))
                .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.mauve, .lav, .mauve]),
                                    center: .center
                                ),
                                lineWidth: 3
                            )
                    )

            Text("SAVE")
                .foregroundColor(.white)
                .font(.system(size: 17))
                .fontWeight(.semibold)
                .padding(5)
        }
        .frame(width: 110, height: 40)
        .padding(.horizontal, 35)
    }
}

#Preview {
    SaveButtonView()
}
