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
            VStack(spacing: 20) {
                if showView5 {
                    Onboarding5View(props: props, showCurrView: $showView5)
                } else {
                    VStack(alignment: .center, spacing: 0) {
                        OnboardingProgressBarView(currentPage: 3)
                            .padding(.bottom, 25)
                        VStack(alignment: .leading, spacing: 20) {
                            Text("What's your current daily average \nunproductive screen time?")
                                .foregroundColor(Color.black)
                                .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                .padding(.leading, 20)
                            
                            
                            Text("Unproductive Screen Time =\nST spent other than for school, work, self-care, etc.")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(.sky)
                                .padding(.bottom, props.isIPad ? 20 : 20)
                        .padding(.leading, props.isIPad ? 100 : 20)
                        .padding(.trailing, props.isIPad ? 100 : 10)
                            
                            
                            
                            ForEach(0..<numberOfRows(), id: \.self) { row in
                                HStack(spacing: 16) {
                                    Spacer()
                                    ForEach(0..<2, id: \.self) { column in
                                        let index = row * 2 + column
                                        if index < unProdSTOptions.count {
                                            OptionButtonView(
                                                props: props,
                                                isSelected: self.$optionsChosen[index],
                                                inputText: self.unProdSTOptions[index],
                                                onSelectionChange: { isSelected in
                                                    self.optionChanged(index: index, isSelected: isSelected)
                                                },
                                                fontSize: props.customFontSize.smallMedium
                                            )
                                        }
                                    }
                                    Spacer()
                                }
                            } .frame(height: 70)
                            Spacer()
                            HStack{
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
                                Spacer()
                            }
                        }
                        
                        
                    }
                    .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 750)
                    .background(
                        RoundedRectangle(cornerRadius: props.round.sheet)
                            .fill(Color.white)
                    )
                    .rotatingBorder()
                }
            }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2)) // Optional: add a background to distinguish the frame
                Spacer(minLength: 20)
            }
            .scrollDisabled(true)
            .contentShape(Rectangle())
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

    private func numberOfRows() -> Int {
           return (unProdSTOptions.count + 1) / 2
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
