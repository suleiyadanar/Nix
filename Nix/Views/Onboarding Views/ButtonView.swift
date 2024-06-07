//
//  GetStartedButtonView.swift
//  Nix
//
//  Created by Grace Yang on 5/31/24.
//

import SwiftUI

struct ButtonView: View {
    
    let text: String
    
    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lemon)
                .offset(x: 3, y: 5)
            
            // Button layer
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lav.opacity(0.9))
                .strokeBorder(Color.mauve, lineWidth: 2)
            
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: 250, height: 60)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    
    }
}

#Preview {
    ButtonView(text: "")
}
