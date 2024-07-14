//
//  Onboarding1View.swift
//  Nix
//
//  Created by Grace Yang on 5/31/24.
//

import SwiftUI

struct Onboarding1View: View {
   
    var body: some View {
            ZStack {
                LinearGradient(colors: [.babyBlue, .lightYellow], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("vector")
                        .padding(.top, 50)
                    Image("vector")
                        .padding(.top, 20)
                    Image("vector")
                        .padding(.top, 20)
                    Image("vector")
                        .padding(.top, 20)
                    Spacer()
                }
                VStack {
                    Text(" ───── Welcome to Nix  ───── ")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .shadow(color: .sky, radius: 0.2)
                        .padding(.top, 80)
                    
                    HStack {
                        Text("Making the \nBest of \nYour College \nJourney")
                            .font(.system(size: 43))
                            .foregroundStyle(.white)
                            .padding(.top, 5)
                            .shadow(color: .sky, radius: 3, x: -4, y:0)
                            .lineSpacing(6)
                            .padding(.leading, 40)
                        Spacer()
                    }
                    
                    Image("chick")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260, height: 260)
                        .offset(y:-30)
                    
                    Text("☆ We're rooting for you! ☆")
                        .font(.system(size: 17))
                        .foregroundStyle(Color.sky)
                        .shadow(color: .white, radius: 0.7)
                        .offset(y:-42)

                    Spacer()
                    NavigationLink(destination: Onboarding2View()) {
                        ButtonView(text:"Get Started") }
                    Spacer()
                
            }
            .ignoresSafeArea()  
            .navigationBarHidden(true)

        }
    }
}

// this extension is to hide the back button and keep swipeback function to go to prev page
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad();
        interactivePopGestureRecognizer?.delegate = self
}

public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
    }
}

//#Preview {
//    Onboarding1View()
//}
