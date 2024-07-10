//
//  Onboarding3AView.swift
//  Nix
//
//  Created by Grace Yang on 6/3/24.
//

import SwiftUI

struct Onboarding3AView: View {
    var props: Properties

    @State private var goalText: String = ""
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack {
                OnboardingProgressBarView(currentPage: 2)
                    .padding(.bottom, 25)
                HStack {
                    Text("\(userSettings.name), what are your goals?")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("Choose up to three goals or write your own! \nYou can update them later in settings.")
                        .foregroundColor(Color.sky)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                
                ForEach(0..<userSettings.goals.count, id: \.self) { index in
                    HStack {
                        Text("Goal #\(index + 1)")
                            .padding(.leading, 20)
                        TextField("Enter goal...", text: $userSettings.goals[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .padding(.leading, 20)
                    }
                    .padding(.vertical)
                }
                if userSettings.goals.count < 3 {
                    VStack {
                        HStack {
                            Text("Goal #\(userSettings.goals.count + 1)")
                                .padding(.leading, 20)
                            Spacer()
                        }
                        HStack {
                            TextField("Enter goal...", text: $goalText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading, 20)
                            Button(action: {
                                if !goalText.isEmpty && userSettings.goals.count < 3 {
                                    userSettings.goals.append(goalText)
                                    goalText = ""
                                }
                            }) {
                                Text("Add")
                                    .font(.system(size: 10))
                                    .padding()
                                    .background(Color.lemon)
                                    .cornerRadius(8)
                                    .foregroundColor(.black)
                            }
                            .padding(.trailing)
                        }
                    }
                    .padding(.vertical)
                }
                Spacer()
                if userSettings.goals.count == 3 {
                    NavigationLink(destination: Onboarding4View(props:props)) {
                        Text("Done")
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

//#Preview {
//    Onboarding3AView()
//}
