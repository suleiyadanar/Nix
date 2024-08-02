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
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
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
        ZStack {
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
                    MainProfileView()
                case "profile":
                    MainProfileView()
                        .ignoresSafeArea()
                default:
                    EmptyView()
                }
                
                
                // Custom Tab Bar
            }   .ignoresSafeArea()
//                .padding(.bottom, 65)
//                .overlay(
//                    CustomTabBar()
//                        .ignoresSafeArea()
//                        .cornerRadius(35)
//                        .padding(.horizontal, 10)
//                        .padding(.top, 10)
//                        .transition(.move(edge: .bottom))
//                    , alignment: .bottom
//                )
            VStack {
                let team = userDefaults?.string(forKey: "team") ?? "water"
                Spacer()
                CustomTabBar(props:props)
                    .ignoresSafeArea()
                    .cornerRadius(35)
                    .background( 
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.teamColor(for: team, type: .fourth).opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                        )
                        .frame(width: props.width)
                    )
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .transition(.move(edge: .bottom))
                    
            }
        }
    }
    
    @ViewBuilder
    func CustomTabBar(props: Properties) -> some View {
        let team = userDefaults?.string(forKey: "team") ?? "water"
       
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
                    .padding(.horizontal, props.width * 0.05) // Adjust horizontal padding proportionally
                    .padding(.vertical, props.height * 0.02) // Adjust vertical padding proportionally
                }
            }
            .background(Color.teamColor(for: team, type: .primary))
            .cornerRadius(35)
            .padding(.horizontal, props.width * 0.03) // Adjust horizontal padding proportionally
            // Ensure the frame is responsive
            .animation(.easeInOut)
        }
    }

}


//#Preview {
//    MainView()
//}
