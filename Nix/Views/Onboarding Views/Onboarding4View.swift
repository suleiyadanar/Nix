import SwiftUI

struct Onboarding4View: View {
    var props: Properties
    @Binding var showCurrView: Bool // Use a Binding to manage the view transition state

    @State private var optionsChosen = Array(repeating: false, count: 6)
    @State private var otherOptionSelected = false
    @EnvironmentObject var userSettings: UserSettings

    @State private var showView5 = false

    var body: some View {
        ScrollView {
            VStack {
                if showView5 {
                    Onboarding5View(props: props, showCurrView: $showView5)
                } else {
                    VStack(spacing: 0) {
                        VStack(spacing: 20) {
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
                            }
                            Spacer()

                            VStack(spacing: 16) {
                                ForEach(0..<6) { index in
                                    OptionButtonView(
                                        isSelected: self.$optionsChosen[index],
                                        inputText: self.unProdSTOptions[index],
                                        onSelectionChange: { isSelected in
                                            self.optionChanged(index: index, isSelected: isSelected)
                                        }
                                    )
                                }
                            }  .frame(height: 400)
                            Spacer()

                            if self.selectedOptionsCount() == 1 {
                                Button(action: {
                                    showView5 = true
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
                        .padding(.horizontal) // Add padding here if needed
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

    private func optionChanged(index: Int, isSelected: Bool) {
        if isSelected {
            for i in 0..<optionsChosen.count {
                if i != index {
                    optionsChosen[i] = false
                }
            }
        }
    }

    private func saveSelectedUnProdST() {
        if let selectedIndex = optionsChosen.firstIndex(where: { $0 }) {
            userSettings.unProdST = unProdSTOptions[selectedIndex]
        }
    }
}

//#Preview {
//    Onboarding4View()
//        .environmentObject(UserSettings())
//}
