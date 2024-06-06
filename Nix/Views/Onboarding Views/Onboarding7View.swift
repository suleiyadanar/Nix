//
//  Onboarding7View.swift
//  Nix
//
//  Created by Grace Yang on 6/5/24.
//

import SwiftUI

struct Onboarding7View: View {
    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack {
                OnboardingProgressBarView(currentPage:6)
                    .padding(.bottom, 25)
                HStack {
                    Text("One more step: Connect us to \nyour Screen Time!")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("")
                        .font(.system(size: 20))
                        .foregroundColor(Color.sky)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                } .padding(.bottom, 60)
                Spacer()
                HStack {
                    Text("Your data is securely protected by Apple and only stays on your phone.")
                        .font(.system(size: 15))
                        .foregroundColor(Color.babyBlue)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                NavigationLink(destination: Onboarding8View()) {
                    ButtonView(text:"Connect")
                }
            }
        
    }
        .navigationBarHidden(true)
    }

}



#Preview {
    Onboarding7View()
}
