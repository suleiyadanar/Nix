import SwiftUI

struct Onboarding2View: View {
    @EnvironmentObject var userSettings: UserSettings
    var props: Properties

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            
            VStack {
                OnboardingProgressBarView(currentPage: 1)
                    .padding(.bottom, 25)
                HStack {
                    Text("Hi, what should we call you?")
                        .foregroundColor(Color.black)
                        .font(.custom("Nunito-Medium", size: props.customFontSize.mediumLarge))
                        .fontWeight(.bold)
//                        .padding(.leading, 20)
                    
                    Spacer()
                }
                HStack {
                    Text("Creating a personalized journey for you... ")
                        .font(.custom("Nunito-Medium", size: props.customFontSize.medium))
                        .foregroundColor(Color.sky)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
//                        .padding(.leading, 20)
                    Spacer()
                }
                NameRectangleView(props:props)
                    .padding(.top, 15)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: Onboarding3View(props:props)) {
                        if (userSettings.name != ""){
                            ArrowButtonView()
                                .padding(.trailing, 20)
                                .padding(.top, 40)
                               
                        }
                     
                    }
                }
                Spacer()
            }.padding()
                .frame(width: props.padding.widthRatio, height:props.padding.heightRatio)
                .background{
                    RoundedRectangle(cornerRadius: props.round.sheet)
                        .fill(Color.white)
                        .frame(width: props.padding.widthRatio, height:props.padding.heightRatio)
                        
                }
        }
        .navigationBarHidden(true)
    }
}

struct NameRectangleView: View {
    @EnvironmentObject var userSettings: UserSettings
    var props: Properties

    var body: some View {
        ZStack {
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.black)
                    .frame(width: 360, height: 50)
                    .opacity(0.06)
                Spacer()
            }
            .overlay(
                TextField("Your name...", text: $userSettings.name)
                    .font(.custom("Nunito-Medium", size: props.customFontSize.medium))
                    .foregroundStyle(Color.black)
                    .padding(.leading, 15)
            )
            .padding(.leading, 20)
        }
    }
}

//#Preview {
//    Onboarding2View()
//        .environmentObject(UserSettings())
//}
