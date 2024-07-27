//
//  Onboarding6View.swift
//  Nix
//
//  Created by Grace Yang on 6/4/24.
//

import SwiftUI
import FamilyControls
import Foundation

struct Onboarding6View: View {
    var props: Properties
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var userSettings: UserSettings
    @Binding var showCurrView: Bool // Use a Binding to manage the view transition state

    @State private var weeks : Int = 0
    @State private var days : Int = 0
    @State private var showChangeDuration: Bool
    @State private var navigationButtonID : UUID

    @State private var showView7 = false

    init(props: Properties, showCurrView: Binding<Bool>){
        self.showChangeDuration = false
        self.navigationButtonID = UUID()
        self.props = props
        self._showCurrView = showCurrView
    }
    
    var body: some View {
        ScrollView{
            VStack {
                if showView7 {
                    Onboarding7View(props: props, showCurrView: $showView7)
                }else{
                    VStack(alignment: .center, spacing:0) {
                        OnboardingProgressBarView(currentPage: 5)
                            .padding(.bottom, 25)
                        VStack(alignment: .leading, spacing:20) {
                            Text("Time needed to achieve your targeted screen time.")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                .fontWeight(.bold)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)
                            
                            Text("Habit building takes time. Reduce 15 mins for 3 days. Repeat :")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(.sky)
                                .padding(.bottom, props.isIPad ? 35 : 20)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)
                            if props.isIPad {
                                Spacer()
                            }
                            
                            GeometryReader { geometry in
                               
                                
                                VStack() {
                                    if props.isIPad {
                                        Spacer()
                                    }
                                    HStack {
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("\(weeks)")
                                                    .font(.custom("Montserrat-Bold", size: 85))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color.lav)
                                                
                                                Text("weeks")
                                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                                    .font(.custom("Montserrat-Bold", size: props.customFontSize.mediumLarge))
                                            }
                                            HStack {
                                                Text("\(days)")
                                                    .font(.custom("Montserrat-Bold", size: 85))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color.lav)
                                                
                                                Text("days")
                                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                                    .font(.custom("Montserrat-Bold", size: props.customFontSize.mediumLarge))
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: geometry.size.width)
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            showChangeDuration.toggle()
                                        }) {
                                            Text("Change Duration")
                                                .font(.custom("Montserrat-Bold", size: props.customFontSize.smallMedium))
                                                .foregroundColor(Color.babyBlue)
                                        }
                                        .sheet(isPresented: $showChangeDuration) {
                                            Onboarding6AView(props: props, weeks: $weeks, days: $days)
                                                .presentationDetents([.height(props.height * 0.7)])
                                        }
                                        Spacer()
                                    }
                                    if props.isIPad {
                                        Spacer()
                                    }
                                }
                                
                                   
                            }
                                
                           
                            
                            Spacer()
                                HStack {
                                    Button(action: {
                                        showView7 = true
                                    }) {
                                        HStack {
                                            Spacer()
                                            ArrowButtonView(props:props)
                                                .padding(.top, 40)
                                                .padding(.bottom, 20)
                                        }.onAppear{
                                            userSettings.totalDays = days + weeks * 7
                                        }
                                        Spacer()
                                    }
                                }
                            
                            
                        }
                       
                    } .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 750)
                        .background(
                            RoundedRectangle(cornerRadius: props.round.sheet)
                                .fill(colorScheme == .dark ? Color.black : Color.white)
                        )
                        .rotatingBorder(props:props)
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
        .onChange(of: userSettings.totalDays) {
            print("changed")
            weeks = userSettings.totalDays / 7
            days = userSettings.totalDays % 7
        }
        .onAppear{
            print("appear")
            weeks = userSettings.totalDays / 7
            days = userSettings.totalDays % 7
        }
    }
}

//#Preview {
//    Onboarding6View()
//}
