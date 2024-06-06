import SwiftUI

struct Onboarding4View: View {
    
    @State private var optionsChosen = Array(repeating: false, count: 6)
    @State private var otherOptionSelected = false

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack {
                OnboardingProgressBarView(currentPage: 3)
                    .padding(.bottom, 25)
                HStack {
                    Text("What's your current daily avg \nunproductive screen time?")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Spacer()
                }
                HStack {
                    Text("Unproductive Screen Time = \nST spent other than for school, work, self \ncare, etc.")
                        .foregroundColor(Color.sky)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                
                ForEach(0..<5) { index in
                    OptionButtonView(isSelected: self.$optionsChosen[index], inputText: self.unProdSTOptions[index])
                }


                if self.selectedOptionsCount() == 1 {
                    NavigationLink(destination: Onboarding5View()) {
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

    private var unProdSTOptions: [String] {
        return [
            "0-1 Hours",
            "1-3 Hours",
            "3-4 Hours",
            "4-5 Hours",
            "5-6 Hours",
            "7+ Hours",
        ]
    }

    private func selectedOptionsCount() -> Int {
        return optionsChosen.filter { $0 }.count + (otherOptionSelected ? 1 : 0)
    }
}


#Preview {
    Onboarding4View()
        .environmentObject(UserSettings())
}
