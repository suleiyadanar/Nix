//
//  ContentView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/15/24.
//

import SwiftUI
import DeviceActivity

struct MainView: View {
    @EnvironmentObject var userSettings: UserSettings

    @StateObject var viewModel = MainViewViewModel()
    @StateObject var registerModel = RegisterViewViewModel()
    @EnvironmentObject var pomodoroModel: PomodoroViewViewModel
    var body: some View  {
       accountView
//        if userSettings.ready {
//            //signed in
//            accountView
//        } else {
//            //            ResponsiveView { properties in
//            NavigationView{
//                Onboarding1View()
////                LoginView().padding(0)
//            }
//            //            }
//        }
        
    }
    
    var tabs = ["homepage", "rules", "pomodoro", "profile"]
    

    @State var selectedTab = "homepage"
    @Namespace var namespace
    
    
    var accountView: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
              
                MainHomepageView(streakCount: 32, progress: 0.6, userId: viewModel.currentUserId)
                    .ignoresSafeArea()
                    .tag("homepage")
                MainRulesView(userId: viewModel.currentUserId, viewModel: RulesViewViewModel(userId: viewModel.currentUserId))
                    .ignoresSafeArea()
                    .tag("rules")
               
                MainPomodoroView(viewModel: pomodoroModel, userId: viewModel.currentUserId)
                    .environmentObject(pomodoroModel)
                    .ignoresSafeArea()
                    .tag("pomodoro")
                
//                RulesView(userId: viewModel.currentUserId)
//                                    .ignoresSafeArea()
//                                    .tag("profile")
                ProfileView()
                    .ignoresSafeArea()
                    .tag("profile")
            }
        }

        .overlay (
            CustomTabBar(),
            alignment: .bottom // moves it to bottom of screen
            
        )
         
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack {
            ForEach(tabs, id: \.self) { image in
                Button {
                    withAnimation(Animation.interactiveSpring(dampingFraction: 1)) {
                        selectedTab = image
                    }
                } label: {
                    // Display the filled image if selected, otherwise display the unfilled image
                    Image(selectedTab == image ? "\(image)-fill" : image)
                        .resizable()
                        .scaledToFit() // Ensure the image maintains its aspect ratio
                        .frame(width: 25, height: 25)
                        .foregroundColor(selectedTab == image ? .black : .gray)
                }
                .padding(.horizontal, 35)
                .padding(.vertical, 20)
            }
        }
        .padding(.vertical, 5)
        .background(Color.babyBlue)
        .cornerRadius(35)
        .padding(.horizontal, 10)
    }
}

//#Preview {
//    MainView()
//}
