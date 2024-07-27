//
//  Onboarding9View.swift
//  Nix
//
//  Created by Grace Yang on 6/5/24.
//

import SwiftUI

struct Onboarding9View: View {
    var props: Properties
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ZStack {
            OnboardingBackgroundView()

            VStack(spacing: 20) {
                HStack {
                    Text("Your Journey\nBegins  Here!")
                        .font(.custom("Bungee-Regular", size: props.customFontSize.large))
                        .foregroundColor(.white)
                        .padding(.top, 55)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
                HStack {
                    Spacer()
                    JourneyMapView(days: userSettings.totalDays, unlockedDays: 1)
                        .frame(width: 300) // Adjust width as needed
                        .cornerRadius(25)
                        .onAppear {
                            print("printing days:\(userSettings.totalDays)")
                        }
                    Spacer()
                }
                    
                              
                Spacer()
                
                NavigationLink (destination: RegisterView(props:props) ) { // temp arrow button to next page
                    HStack {
                        Spacer()
                        ArrowButtonView(props:props)
                            .padding(.trailing, 35)
                            .padding(.bottom, 40)
                    }
                }
            }.padding(20)
                          
        }
        .navigationBarHidden(true)
    }
}



//#Preview {
//    Onboarding9View()
//}
