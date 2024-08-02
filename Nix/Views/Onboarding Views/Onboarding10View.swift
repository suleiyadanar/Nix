//
//  Onboarding10View.swift
//  Nix
//
//  Created by Grace Yang on 6/5/24.
//

import SwiftUI

struct Onboarding10View: View {
    var props: Properties

    @EnvironmentObject var userSettings: UserSettings

    @StateObject var viewModel = RegisterViewViewModel()
    var body: some View {
        ZStack {
            LinearGradient(colors: [.babyBlue, .lightYellow], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Text("Woohoo!")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("You're \nIn!")
                        .font(.system(size: 90))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.sky)
                        .padding(.top, 15)
                        .overlay(
                            Text("You're \nin!")
                                .font(.system(size: 90))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.top, 15)
                                .offset(x: -4, y: 4)
                            
                        )
                    Spacer()
                }
                
                Spacer()
                
                Text("So proud of you for \ntaking the first step")
                    .bold()
                    .padding(.bottom, 15)
                    .offset(y:-10)
                
                NavigationLink(destination: MainView(props:props)) {
                                    Button(action: {
                                       
                                    }) {
                                        ButtonView(props: props, text: "Let's do it", imageName: nil)
                                    }
                                }
                .offset(y:-10)

            }
                          
        }
        .navigationBarHidden(true)
    }
}
