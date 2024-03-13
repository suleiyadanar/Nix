//
//  ContentView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/15/24.
//

import SwiftUI
import DeviceActivity

struct MainView: View {

    
    @StateObject var viewModel = MainViewViewModel()
    var body: some View  {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            //signed in
            accountView
        }else {
//            ResponsiveView { properties in
            NavigationView{
                LoginView().padding(0)
            }
//            }
        }
            
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            HomepageView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            RulesView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("Rules", systemImage: "chart.bar.doc.horizontal")
                }
                
                PomodoroView()
                    .tabItem {
                        Label("Pomodoro", systemImage: "timer")
                    }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "profile.circle")
                }
            
        }
    }
}

//#Preview {
//    MainView()
//}
