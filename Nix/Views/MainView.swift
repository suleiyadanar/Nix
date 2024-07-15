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
    var props: Properties

    @StateObject var viewModel = MainViewViewModel()
    @StateObject var registerModel = RegisterViewViewModel()
    @EnvironmentObject var pomodoroModel: PomodoroViewViewModel

    var body: some View  {
//       accountView
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            //signed in
            accountView.ignoresSafeArea()
        } else {
            ResponsiveView { props in
            NavigationStack{
                Onboarding1View(props:props)
//                LoginView().padding(0)
            }
                        }
        }
        
    }
    
    
    var tabs = ["homepage", "rules", "pomodoro", "profile"]
    

    @State var selectedTab = "homepage"
    @State var showTabBar = true // State variable to control the visibility of the CustomTabBar

    @Namespace var namespace
    
    
    var accountView: some View {
            VStack {
                // Display the selected view based on selectedTab
                switch selectedTab {
                case "homepage":
                    MainHomepageView(props: props, streakCount: 32, progress: 0.6, userId: viewModel.currentUserId, showTabBar: $showTabBar)
                        .ignoresSafeArea()
                case "rules":
                    MainRulesView(props: props, userId: viewModel.currentUserId, viewModel: RulesViewViewModel(userId: viewModel.currentUserId))
                        .ignoresSafeArea()
                case "pomodoro":
                    MainPomodoroView(props: props, viewModel: pomodoroModel, userId: viewModel.currentUserId)
                        .environmentObject(pomodoroModel)
                        .ignoresSafeArea()
                case "profile":
                    ProfileView(props: props)
                        .ignoresSafeArea()
                default:
                    EmptyView()
                }

                
                // Custom Tab Bar
            }   .ignoresSafeArea()
            .overlay(
                
                CustomTabBar()
                    .padding(.bottom)
                    .ignoresSafeArea()
                    .background(Color.babyBlue)
                    .cornerRadius(35)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .transition(.move(edge: .bottom))
                , alignment: .bottom
            )
        }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
           if showTabBar {
               HStack {
                   ForEach(tabs, id: \.self) { image in
                       Button {
                           withAnimation(Animation.interactiveSpring(dampingFraction: 1)) {
                               selectedTab = image
                           }
                       } label: {
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
               .ignoresSafeArea()
               .background(Color.babyBlue)
               .cornerRadius(35)
               .padding(.horizontal, 10)
               .animation(.easeInOut)
           }
       }
}


//#Preview {
//    MainView()
//}
