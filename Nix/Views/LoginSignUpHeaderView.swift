//
//  LoginSignUpHeaderView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/18/24.
//

import SwiftUI

struct LoginSignUpHeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack {
            Image("nix-icon").scaledToFit().background(Color.black).padding(.top,100)
            Text(title)
                .font(.custom("Inter", fixedSize: 40))
                .bold()
                .padding(.top, 50)
            Text(subtitle)
        }
    }
}

#Preview {
    LoginSignUpHeaderView(title: "Title", subtitle: "Subtitle")
}
