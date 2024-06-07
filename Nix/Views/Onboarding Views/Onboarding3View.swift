import SwiftUI

struct Onboarding3View: View {
    @State private var optionsChosen = Array(repeating: false, count: 7)
    @State private var otherOptionSelected = false
    @State private var goalText = ""
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
 
        ZStack {
            OnboardingBackgroundView()
            VStack {
                OnboardingProgressBarView(currentPage: 2)
                    .padding(.bottom, 25)
                HStack {
                    Text("\(userSettings.name), what are your goals?")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("Choose up to three goals or write your own! You can update them later in the settings.")
                        .foregroundColor(Color.sky)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                ForEach(0..<6) { index in
                    OptionButtonView(isSelected: self.$optionsChosen[index], inputText: self.screenTimeOptions[index])
                }
                Image("dottedline")
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                NavigationLink(destination: Onboarding3AView()) {
                    OtherButtonView()
                }
                if self.selectedOptionsCount() == 3 {
                    NavigationLink(destination: Onboarding4View()) {
                        ArrowButtonView()
                            .padding(.trailing, 20)
                            .padding(.top, 40)
                    }
                }
                Spacer()
            }
            
        }
        .navigationBarHidden(true)
    }

    private var screenTimeOptions: [String] {
        return [
            "Improve grades",
            "Spend more time socializing",
            "Club activities",
            "Improve sleep quality",
            "More time for self-care",
            "Career growth",
            "Increased mindfulness"
        ]
    }

    private func selectedOptionsCount() -> Int {
        return optionsChosen.filter { $0 }.count + (otherOptionSelected ? 1 : 0)
    }
}

struct OtherButtonView: View {

    var body: some View {
        
        ZStack {
            Rectangle()
                .background(Color.babyBlue)
                .frame(width: 300, height: 45)
                .cornerRadius(15)
            VStack {
                Spacer()
                Text("Write my own!")
                    .padding(.leading, 15)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        
    }
}

