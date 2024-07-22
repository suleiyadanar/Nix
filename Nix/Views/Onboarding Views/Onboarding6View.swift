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
                    VStack(spacing:0) {
                        VStack(spacing:20){
                        OnboardingProgressBarView(currentPage: 5)
                            .padding(.bottom, 15)
                        
                        HStack {
                            Text("We believe in progressive\nScreen Time Reduction.")
                                .font(.system(size: 25))
                                .font(.title2)
                                .bold()
                                .padding(.leading, 10)
                                .padding(.bottom, 8)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Science shows that habit building takes time.\nAccording to our calculations ...")
                                .font(.subheadline)
                                .foregroundColor(Color.sky)
                                .padding(.leading, 10)
                                .padding(.bottom, 22)
                            Spacer()
                        }
                        
                        HStack {
                            Text("The optimal time to\nachieve your targeted\nscreen time is:")
                                .font(.title3)
                                .font(.system(size: 35))
                                .bold()
                                .padding(.leading, 10)
                        }
                            Spacer()
                        VStack{
                            HStack{
                                Text("\(weeks)")
                                    .font(.system(size: 85))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.lav)
                                
                                Text("weeks")
                                    .font(.title3)
                                    .bold()
                                
                            }
                            HStack{
                                Text("\(days)")
                                    .font(.system(size: 85))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.lav)
                                
                                Text("days")
                                    .font(.title3)
                                    .bold()
                                
                            }
                        }
                        Spacer()
                        
                        Button(action: {
                            showChangeDuration.toggle()
                        }) {
                            Text("Change duration")
                                .foregroundColor(Color.babyBlue)
                        }
                        .sheet(isPresented: $showChangeDuration) {
                            Onboarding6AView(weeks: $weeks, days: $days)
                                .presentationDetents([.height(UIScreen.main.bounds.height * 0.7)])
                        }
                        
                        
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
                        }
                        
                    }.padding()
                            .frame(height:1000)
                            .background(
                                RoundedRectangle(cornerRadius: props.round.sheet)
                                    .fill(Color.white)
                            )
                            .padding(.horizontal) // Add padding here if needed
                       
                }.frame(height:1000)
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
//    Onboarding6View()
//}
