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

    @State private var weeks : Int
    @State private var days : Int
    @State private var showChangeDuration: Bool
    @State private var navigationButtonID : UUID

    @State private var showView7 = false

    init(weeks: Int, days:Int, props: Properties, showCurrView: Binding<Bool>){
        self.weeks = weeks
        self.days = days
        self.showChangeDuration = false
        self.navigationButtonID = UUID()
        self.props = props
        self._showCurrView = showCurrView
        print(weeks)
        print(days)
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
                            Text("We believe in progressive Screen Time Reduction.")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                .fontWeight(.bold)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)
                            
                            Text("Habit building takes time. According to our calculations,the optimal time to achieve your targeted screen time:")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(.sky)
                                .padding(.bottom, props.isIPad ? 20 : 20)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)
                            
                            GeometryReader { geometry in
                                VStack(spacing: 40) {
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
                                }
                            }
                                
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
                                        .presentationDetents([.height(UIScreen.main.bounds.height * 0.7)])
                                }
                                Spacer()
                            }
                            
                            Spacer()
                                HStack {
                                    Button(action: {
                                        showView7 = true
                                    }) {
                                        HStack {
                                            Spacer()
                                            ArrowButtonView()
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
//    Onboarding6View()
//}
