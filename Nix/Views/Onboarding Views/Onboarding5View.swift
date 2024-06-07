//
//  Onboarding5View.swift
//  Nix
//
//  Created by Grace Yang on 6/2/24.
//

import SwiftUI

struct Onboarding5View: View {
    @State private var hours: Int = 6
        @State private var minutes: Int = 30

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack() {
                OnboardingProgressBarView(currentPage: 4)
                    .padding(.bottom, 25)
                
                HStack {
                    Text("Maximum limit for unproductive Screen Time?")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Spacer()
                }
                
                HStack {
                    Text("Unproductive Screen Time = ST spent other than for school, work, self care, etc.")
                        .foregroundColor(Color.sky)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                
                VStack(spacing: 40) {
                    VStack {
                        HStack {
                            Button(action: {
                                if hours > 0 {
                                    hours -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.lemon)
                                    .padding(.trailing, 10)
                            }
                            Text("\(String(format: "%02d", hours))")
                                .font(.largeTitle)
                            Button(action: {
                                if hours < 23 {
                                    hours += 1
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.lemon)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                            }
                            Text("hr")
                                .font(.largeTitle)
                              
                        }
                        .offset(x: -12)
                        
                    }
                    
                    VStack {
                        HStack {
                            Button(action: {
                                if minutes > 0 {
                                    minutes -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.lemon)
                                    .padding(.trailing, 10)
                            }
                            Text("\(String(format: "%02d", minutes))")
                                .font(.largeTitle)
                            Button(action: {
                                if minutes < 59 {
                                    minutes += 1
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.lemon)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 10)
                            }
                            Text("min")
                                .font(.largeTitle)
                        }
                       
                    }
                }
                .padding(.vertical, 20)
                
                NavigationLink (destination: Onboarding6View() ) {
                    HStack {
                        Spacer()
                        ArrowButtonView()
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
        }
        
        .navigationBarHidden(true)
    }
}

#Preview {
    Onboarding5View()
}
