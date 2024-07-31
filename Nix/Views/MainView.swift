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
    @State private var emailVerified: Bool = false // Changed to @State

    var body: some View  {
//       accountView
        Group {
                    if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                        // User is signed in
                        accountView.ignoresSafeArea()
                        // check if email is verified
                    } else {
                        ResponsiveView { props in
                            NavigationStack {
                                Onboarding1View(props: props)
                                    .environmentObject(userSettings)
                            }
                        }
                    }
                }
//                .onAppear {
//                    checkEmailVerification()
//                }
        
    }
    
    
    var tabs = ["home", "rule", "timer", "face"]
    

    @State var selectedTab = "home"
    @State var showTabBar = true // State variable to control the visibility of the CustomTabBar

    @Namespace var namespace
    
//    private func checkEmailVerification() {
//            registerModel.checkEmailVerificationStatus { isVerified in
//                emailVerified = isVerified
//                if isVerified {
//                    print("Email is verified.")
//                } else {
//                    print("Email is not verified.")
//                }
//            }
//        }
    
    var accountView: some View {
            VStack {
                // Display the selected view based on selectedTab
                switch selectedTab {
                case "home":
                    MainHomepageView(props: props, streakCount: 32, progress: 0.6, userId: viewModel.currentUserId, showTabBar: $showTabBar)
                        .ignoresSafeArea()
                case "rule":
                    MainRulesView(props: props, userId: viewModel.currentUserId, viewModel: RulesViewViewModel(userId: viewModel.currentUserId))
                        .ignoresSafeArea()
                case "timer":
                    MainPomodoroView(props: props, viewModel: pomodoroModel, userId: viewModel.currentUserId)
                        .environmentObject(pomodoroModel)
                        .ignoresSafeArea()
                case "face":
                    ProfileView(props: props)
                        .ignoresSafeArea()
                default:
                    EmptyView()
                }

                
                // Custom Tab Bar
            }   .ignoresSafeArea()
            .padding(.bottom, 65)
            .overlay(
                CustomTabBar()
                    .ignoresSafeArea()
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
