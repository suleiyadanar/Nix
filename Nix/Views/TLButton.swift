//
//  TLButton.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/18/24.
//

import SwiftUI

struct TLButton: View {
    let text: String
    let background: Color
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label : {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(red: 0.59, green: 0.68, blue:0.82))
                    .frame(width: 275, height: 50)
                    .cornerRadius(150)
                Text(text).foregroundColor(background)
            }.padding(.top, 50)
        }
    }
}

#Preview {
    TLButton(text: "Login", background: Color.black){
        // Action
    }
}
