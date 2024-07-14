//
//  Onboarding9View.swift
//  Nix
//
//  Created by Grace Yang on 6/5/24.
//

import SwiftUI

struct Onboarding9View: View {
    var props: Properties

    var body: some View {
        ZStack {
            LinearGradient(colors: [.babyBlue, .lightYellow], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Your  Journey \nBegins  Here!")
                        .font(.largeTitle)
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                        .foregroundColor(.sky)
                        .padding(.top, 55)
                        .padding(.leading, 35)
                        .overlay(
                            Text("Your  Journey \nBegins  Here!")
                                .font(.largeTitle)
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 55)
                                .padding(.leading, 35)
                                .offset(x: 2, y: 2)

                            )
                    Spacer()
                }
                Spacer()
                
                NavigationLink (destination: RegisterView(props:props) ) { // temp arrow button to next page
                    HStack {
                        Spacer()
                        Text("temp arrow button lolz")
                        ArrowButtonView()
                            .padding(.trailing, 35)
                            .padding(.bottom, 40)
                    }
                }
            }
                          
        }
        .navigationBarHidden(true)
    }
}



//#Preview {
//    Onboarding9View()
//}
