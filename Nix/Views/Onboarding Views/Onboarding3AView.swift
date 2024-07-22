//
//  Onboarding3AView.swift
//  Nix
//
//  Created by Grace Yang on 6/3/24.
//

import SwiftUI

struct Onboarding3AView: View {
    var props: Properties
    @Binding var showCurrView: Bool // Use a Binding to manage the view transition state

    @State private var goalText: String = ""
    @EnvironmentObject var userSettings: UserSettings
    @State private var showView4 = false

    var body: some View {
        ScrollView{
            VStack{
                if showView4 {
                    Onboarding4View(props: props, showCurrView: $showView4)
                } else {
                    VStack (spacing:0){
                        VStack (spacing:20) {
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
                           
                                Button(action: {
                                    showView4 = true
                                }){
                                    if userSettings.goals.count > 1 {
                                        ArrowButtonView()
                                            .padding(.top, 40)
                                            .padding(.bottom, 20)
                                }
                            }
                        }
                        .padding()
                        .frame(height:1000)
                        .background(
                            RoundedRectangle(cornerRadius: props.round.sheet)
                                .fill(Color.white)
                        )
                        .padding(.horizontal) // Add padding here if needed
                    }
                    .frame(height:1000)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2)) // Optional: add a background to distinguish the frame
            Spacer(minLength: 20)
        }
        .scrollDisabled(true)
                
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 100 { // Adjust the threshold as needed
                            showCurrView = false
                        }
                    }
            )
        
    }
}

//#Preview {
//    Onboarding3AView()
//}
