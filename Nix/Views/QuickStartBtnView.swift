//
//  QuickStartBtnView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/19/24.
//

import SwiftUI

struct QuickStartBtnView: View {
    @Environment(\.colorScheme) var colorScheme
    let time: String
    let rule: String
    let iconName: String
    
    var body: some View {
        Button{
            //Action
        } label: {
            VStack {
                Image(systemName: iconName).padding(5)
                Text(time)
                Text(rule).font(.subheadline).fontWeight(.heavy)
            }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 15)
        .background(
              RoundedRectangle(cornerRadius: 15)
                .stroke(Color(red: 0.6, green: 0.7, blue:0.9), lineWidth: 4)
                .shadow(color: Color(red: 0.8, green: 0.9, blue:0.9), radius: 4, x:3, y: 5)
            )
    }
}

#Preview {
    QuickStartBtnView(time: "25 min", rule: "Me Time", iconName:  "person")
}
