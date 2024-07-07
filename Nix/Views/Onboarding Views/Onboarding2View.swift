import SwiftUI

struct Onboarding2View: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack {
                OnboardingProgressBarView(currentPage: 1)
                    .padding(.bottom, 25)
                HStack {
                    Text("What should we call you?")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("Creating a personalized journey for you... ")
                        .font(.system(size: 20))
                        .foregroundColor(Color.sky)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                NameRectangleView()
                    .padding(.top, 15)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: Onboarding3View()) {
                        if (userSettings.name != ""){
                            ArrowButtonView()
                                .padding(.trailing, 20)
                                .padding(.top, 40)
                               
                        }
                     
                    }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct NameRectangleView: View {
    @EnvironmentObject var userSettings: UserSettings

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
                    .foregroundStyle(Color.black)
                    .padding(.leading, 15)
            )
            .padding(.leading, 20)
        }
    }
}

#Preview {
    Onboarding2View()
        .environmentObject(UserSettings())
}
