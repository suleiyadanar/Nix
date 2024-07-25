//
//  Onboarding3AView.swift
//  Nix
//
//  Created by Grace Yang on 6/3/24.
//

import SwiftUI

struct Onboarding3AView: View {
    var props: Properties
    @Environment(\.colorScheme) var colorScheme

    @Binding var showCurrView: Bool // Use a Binding to manage the view transition state

    @State private var goalText: String = ""
    @EnvironmentObject var userSettings: UserSettings
    @State private var showView4 = false

    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                if showView4 {
                    Onboarding4View(props: props, showCurrView: $showView4)
                } else {
                    VStack (alignment: .center, spacing:0){
                        OnboardingProgressBarView(currentPage: 2)
                            .padding(.bottom, 25)
                        VStack (alignment: .leading, spacing:20) {
                                Text("\(userSettings.name), what are your goals?")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                .fontWeight(.bold)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)
                               
                      
                                Text("Choose up to three goals or write your own! You can update them later in settings.")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(.sky)
                                .padding(.bottom, props.isIPad ? 20 : 20)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)
                            
                            
                            ForEach(0..<userSettings.goals.count, id: \.self) { index in
                                HStack(spacing: 16) {
                                    Spacer()

                                    Text("Goal #\(index + 1)")
                                        .padding(.leading, 20)
                                        .foregroundColor(Color.black)
                                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                    TextField("Enter goal...", text: $userSettings.goals[index])
                                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                        .background(Color.white)
                                        .padding(.leading, 20)
                                        .textFieldStyle(PlainTextFieldStyle())

                                    Spacer()
                                }
                                .padding(.vertical)
                            }
                            if userSettings.goals.count < 3 {
                                VStack {
                                    HStack {
                                        Text("Goal #\(userSettings.goals.count + 1)")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(Color.black)
                                            .padding(.leading, 20)
                                        Spacer()
                                    }
                                    HStack {
                                        TextField("Enter goal...", text: Binding(
                                               get: {
                                                   goalText
                                               },
                                               set: { newValue in
                                                   if newValue.count <= 20 {
                                                       goalText = newValue
                                                   }
                                               }
                                           ))
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .padding(.leading, 20)
                                            .background(Color.white)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .frame(width: props.width * 0.6, height: 50)
                                        Button(action: {
                                            if !goalText.isEmpty && userSettings.goals.count < 3 {
                                                userSettings.goals.append(goalText)
                                                goalText = ""
                                            }
                                        }) {
                                            Text("Add")
                                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
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
                    }
                    .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 750)
                    .background(
                        RoundedRectangle(cornerRadius: props.round.sheet)
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                    )
                    .rotatingBorder()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer(minLength: 20)
        }
        .scrollDisabled(true)
        .contentShape(Rectangle())

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
