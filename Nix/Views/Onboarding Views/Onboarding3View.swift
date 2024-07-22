import SwiftUI

struct Onboarding3View: View {
    var props: Properties
    @Binding var showCurrView: Bool // Use a Binding to manage the view transition state

    @State private var optionsChosen = Array(repeating: false, count: 7)
    @State private var otherOptionSelected = false
    @State private var goalText = ""
    @EnvironmentObject var userSettings: UserSettings

    @State private var showView4 = false
    @State private var showView3A = false

    var body: some View {
        ScrollView {
            VStack {
                if showView4 {
                    Onboarding4View(props: props, showCurrView: $showView4)
                } else if showView3A {
                    Onboarding3AView(props: props, showCurrView: $showView3A)
                } else {
                    VStack(spacing: 0) {
                        VStack(spacing: 20) {
                            OnboardingProgressBarView(currentPage: 2)
                                .padding(.bottom, 25)
                            HStack {
                                Text("\(userSettings.name), what are your goals?")
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                    .padding(.leading, 20)
                                    .font(.custom("Nunito-Medium", size: props.customFontSize.mediumLarge))
                                Spacer()
                            }
                            HStack {
                                Text("Choose up to three goals or write your own! You can update them later in the settings.")
                                    .foregroundColor(Color.sky)
                                    .font(.custom("Nunito-Medium", size: props.customFontSize.medium))
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 20)
                                    .padding(.leading, 20)
                            }
                            Spacer()
                            VStack(spacing: 16) {
                                ForEach(0..<7) { index in
                                    OptionButtonView(
                                        isSelected: self.$optionsChosen[index],
                                        inputText: self.screenTimeOptions[index],
                                        onSelectionChange: { isSelected in
                                            self.optionChanged(index: index, isSelected: isSelected)
                                        }
                                    )
                                }
                            }
                            .frame(height: 400)
                            Image("dottedline")
                                .padding(.top, 20)
                                .padding(.bottom, 20)

                            Button(action: {
                                showView3A = true
                            }) {
                                OtherButtonView()
                            }
                            .frame(height: 45)

                            Spacer()

                            if self.selectedOptionsCount() > 0 {
                                Button(action: {
                                    showView4 = true
                                }) {
                                    ArrowButtonView()
                                }
                                .padding(.top, 40)
                                .padding(.bottom, 20)
                            } else {
                                Rectangle()
                                    .foregroundColor(Color.clear)
                                    .frame(height: 35) // Adjust height as needed
                                    .padding(.top, 40)
                                    .padding(.bottom, 20)
                            }
                        }
                        .padding()
                        .frame(height: 1000)
                        .background(
                            RoundedRectangle(cornerRadius: props.round.sheet)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                    }
                    .frame(height: 1000)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    private func optionChanged(index: Int, isSelected: Bool) {
        if isSelected && selectedOptionsCount() > 3 {
            optionsChosen[index] = false
        }
    }

    private func saveSelectedGoals() {
        userSettings.goals = optionsChosen.enumerated().compactMap { index, isSelected in
            isSelected ? screenTimeOptions[index] : nil
        }
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
