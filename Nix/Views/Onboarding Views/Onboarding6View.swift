//
//  Onboarding6View.swift
//  Nix
//
//  Created by Grace Yang on 6/4/24.
//

import SwiftUI
import FamilyControls

struct Onboarding6View: View {
    var props: Properties

    @State private var weeks: Int = 8
    @State private var showChangeDuration: Bool = false
    @State private var navigationButtonID = UUID()

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack() {
                
                OnboardingProgressBarView(currentPage: 5)
                    .padding(.bottom, 15)
                    .offset(y:-15)
                
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
                    Spacer()
                }
                
                Text("\(weeks)")
                    .font(.system(size: 85))
                    .fontWeight(.bold)
                    .foregroundColor(Color.lav)
                
                Text("weeks")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 7)
                
                Button(action: {
                    showChangeDuration.toggle()
                }) {
                    Text("Change duration")
                        .foregroundColor(Color.babyBlue)
                }
                .sheet(isPresented: $showChangeDuration) {
                    Onboarding6AView(weeks: $weeks)
                        .presentationDetents([.height(UIScreen.main.bounds.height * 0.7)])
                    
                    
                }
                
                Spacer()
                
                NavigationLink (destination: Onboarding7View(props:props) ) {
                    HStack {
                        Spacer()
                        ArrowButtonView()
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
            .padding()
            
        }
        
        .navigationBarHidden(true)
        
    }
}

//#Preview {
//    Onboarding6View()
//}
