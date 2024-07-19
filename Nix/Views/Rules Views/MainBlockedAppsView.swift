//
//  MainBlockedAppsView.swift
//  Nix
//
//  Created by Grace Yang on 7/18/24.
//

import SwiftUI

struct MainBlockedAppsView: View {
    @State private var selectedTab = 0
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            HStack {
                
                Image("new-rule-icon")
                Text("Blocked Apps ")
                    .font(.system(size: 25))
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 15)
            
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
            .padding(.bottom, 10)
            
            if selectedTab == 0 {
                AppGroupsView()
            } else {
                ChooseAppsView()
            }
            
            Spacer()
            
            Button(action: {
                isPresented = false
            }) {
                SaveButtonView()
            }
            
        }
        .padding(15)
        .padding(.horizontal, 10)
    }
}


struct AppGroupsView: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                // add action
            }) {
                HStack {
                    Text("Add More")
                    Image(systemName: "plus.circle")
                }
                .padding(10)
                .foregroundStyle(Color.mauve)
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .background(Color.lemon)
                .cornerRadius(20)
            }
        }
        
        VStack(spacing: 10) {
            Button(action: {
                // add action
            }) {
                HStack {
                    Text("Distracting Apps")
                        .foregroundStyle(Color.black)
                    Spacer()
                    Text("5 apps blocked")
                        .foregroundStyle(Color.black)
                }
                .padding(12)
                .background(Color.lemon)
                .cornerRadius(15)
            }
            
            Button(action: {
                // add action
            }) {
                HStack {
                    Text("Social Media")
                        .foregroundStyle(Color.black)
                    Spacer()
                    Text("12 apps blocked")
                        .foregroundStyle(Color.black)
                }
                .padding(12)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(15)
            }
        }
    }
}


struct ChooseAppsView: View {
    var body: some View {
        Text("Hello")

    }
}
