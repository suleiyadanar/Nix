//
//  MainBlockedAppsView.swift
//  Nix
//
//  Created by Grace Yang on 7/18/24.
//

import SwiftUI

struct MainBlockedAppsView: View {
    @State private var selectedTab = 0

    var body: some View {
        
        HStack {
            Button(action: {
                selectedTab = 0
            }) {
                Text("App Groups")
                    .frame(maxWidth: .infinity, maxHeight: 35)
                    .background(selectedTab == 0 ? Color.babyBlue : Color.clear)
                    .foregroundStyle(selectedTab == 0 ? Color.white : Color.black)
                    .cornerRadius(5)
            }
            Button(action: {
                selectedTab = 1
            }) {
                Text("Choose Apps")
                    .frame(maxWidth: .infinity,  maxHeight: 35)
                    .background(selectedTab == 1 ? Color.babyBlue : Color.clear)
                    .foregroundStyle(selectedTab == 1 ? Color.white : Color.black)
                    .cornerRadius(5)
            }
        }
        .padding(.bottom, 20)

    }
}

#Preview {
    MainBlockedAppsView()
}
