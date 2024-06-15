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
    @EnvironmentObject var pomodoroModel: PomodoroViewViewModel
    var body: some View  {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            //signed in
            accountView
        } else {
            //            ResponsiveView { properties in
            NavigationView{
                Onboarding1View()
                //LoginView().padding(0)
            }
            //            }
        }
        
    }
    
    var tabs = ["house.fill", "chart.bar.doc.horizontal.fill", "timer.circle.fill", "person.crop.circle.fill"]
    

    @State var selectedTab = "house.fill"
    @Namespace var namespace
    
    
    var accountView: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                MainHomepageView(streakCount: 32, progress: 0.6, userId: viewModel.currentUserId)
                    .ignoresSafeArea()
                    .tag("house.fill")
                RulesView(userId: viewModel.currentUserId)
                    .ignoresSafeArea()
                    .tag("chart.bar.doc.horizontal.fill")
                PomodoroView(viewModel: pomodoroModel)
                    .environmentObject(pomodoroModel)
                    .ignoresSafeArea()
                    .tag("timer.circle.fill")
                ProfileView()
                    .ignoresSafeArea()
                    .tag("person.crop.circle.fill")
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
        HStack(spacing: 15) {
            ForEach(tabs, id: \.self) { image in
                Button {
                    withAnimation(Animation.interactiveSpring(dampingFraction: 2)) {
                        selectedTab = image
                    }
                } label: {
                    VStack {
                        Image(systemName: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(selectedTab == image ? .purple : .gray)
                      
                        if (selectedTab == image) {
                            Rectangle()
                                .frame(width: 35, height: 3)
                                .foregroundColor(.purple)
                                .padding(.top, 2)
                        }
                    }
                        
                }
                
                .padding(.horizontal, 20)
                .padding(.vertical, 13)

            }
            
            
        }
        
        .background(Color.lavender)
        .cornerRadius(35)
        .padding(.bottom, 20)        
        
    }
}

//#Preview {
//    MainView()
//}
