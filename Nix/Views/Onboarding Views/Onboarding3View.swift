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
            VStack(spacing: 20) {
                if showView4 {
                    Onboarding4View(props: props, showCurrView: $showView4)
                } else if showView3A {
                    Onboarding3AView(props: props, showCurrView: $showView3A)
                } else {
                    VStack(alignment: .center, spacing: 0) {
                        OnboardingProgressBarView(currentPage: 2)
                            .padding(.bottom, 25)
                        VStack(alignment: .leading, spacing: 20) {
                                Text("\(userSettings.name), what are your goals?")
                                    .foregroundColor(.black)
                                    .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                    .fontWeight(.bold)
                                    .padding(.leading, props.isIPad ? 100 : 20)
                                    .padding(.trailing, props.isIPad ? 100 : 10)
                                
                                
                                Text("Choose up to three goals or write your own! You can update them later in the settings.")
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
                                                    if index < screenTimeOptions.count {
                                                        OptionButtonView(
                                                            props:props,
                                                            isSelected: self.$optionsChosen[index],
                                                            inputText: self.screenTimeOptions[index],
                                                            onSelectionChange: { isSelected in
                                                                self.optionChanged(index: index, isSelected: isSelected)
                                                            }, fontSize: props.customFontSize.smallMedium
                                                        )
                                                    }
                                                }
                                                Spacer()
                                            }
                                        }.frame(height:70)
                                    

//                            Image("dottedline")
//                                .padding(.top, props.isIPad ? 20 : 10)
//                                .padding(.bottom, props.isIPad ? 20 : 10)
                            HStack{
                                Spacer()
                                Button(action: {
                                    showView3A = true
                                }) {
                                    OtherButtonView(props:props)
                                }
                                .frame(height: 45)
                                Spacer()
                            }
                            Spacer()
                            HStack{
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
    private func numberOfRows() -> Int {
           return (screenTimeOptions.count + 1) / 2
       }
       
     
    private var screenTimeOptions: [String] {
        return [
            "Improve Grades",
            "Social Time",
            "Club Activities",
            "Sleep Quality",
            "Self-care",
            "Career Growth",
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
    var props: Properties

    var body: some View {
        ZStack {
            Rectangle()
                .background(Color.babyBlue)
                .frame(width: 300, height: 45)
                .cornerRadius(15)
            VStack {
                Spacer()
                Text("Write my own!")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                Spacer()
            }
        }
    }
}
