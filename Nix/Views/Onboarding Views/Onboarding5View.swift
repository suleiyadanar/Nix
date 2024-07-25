import SwiftUI

struct Onboarding5View: View {
    @Environment(\.colorScheme) var colorScheme
    var props: Properties
    @Binding var showCurrView: Bool // Use a Binding to manage the view transition state

    @State private var hours: Int = 0
    @State private var minutes: Int = 30
    
    @State private var weeks : Int = 0
    @State private var days : Int = 0
    
    @State private var showHoursPopover = false
    @State private var showMinutesPopover = false
    @EnvironmentObject var userSettings: UserSettings

    @State private var showView6 = false

    var body: some View {
        ScrollView{
        VStack {
            if showView6 {
                Onboarding6View(weeks: weeks, days: days, props: props, showCurrView: $showView6)
            }else{
                VStack(alignment: .center, spacing:0){
                    OnboardingProgressBarView(currentPage: 4)
                        .padding(.bottom, 25)
                    VStack(alignment: .leading, spacing:20) {
                            Text("Maximum limit for unproductive Screen Time?")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)

                            Text("Unproductive Screen Time =\nST spent other than for school, work, self care, etc.")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(.sky)
                                .padding(.bottom, props.isIPad ? 20 : 30)
                        .padding(.leading, props.isIPad ? 100 : 20)
                        .padding(.trailing, props.isIPad ? 100 : 10)
                    
                        VStack(alignment: .leading, spacing: 40) {
                                        HStack {
                                            Spacer()
                                            Text("\(hours)")
                                                .foregroundColor(colorScheme == .dark ? Color.black : Color.black)
                                                .font(.custom("Montserrat-Bold", size: props.customFontSize.mediumLarge))
                                                .frame(width: 50) // Fixed width for the capsule

                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 12)
                                                .background {
                                                    Capsule()
                                                        .fill(Color.lemon)
                                                }
                                                .onLongPressGesture {
                                                    showHoursPopover.toggle()
                                                }
                                                .popover(isPresented: $showHoursPopover) {
                                                    PopoverContentView(maxValue: 24, minValue: 0, step: 1) { value in
                                                        hours = value
                                                        showHoursPopover = false
                                                    }
                                                    .onDisappear {
                                                        calculateDays()
                                                    }
                                                }
                                            Text("hr")
                                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                                .font(.custom("Montserrat-Bold", size: props.customFontSize.mediumLarge))
                                                .frame(width: 70, alignment: .leading)

                                            Spacer()

                                        }
                                        HStack {
                                            Spacer()

                                            Text("\(minutes)")
                                                .foregroundColor(colorScheme == .dark ? Color.black : Color.black)
                                                .font(.custom("Montserrat-Bold", size: props.customFontSize.mediumLarge))
                                                .frame(width: 50) // Fixed width for the capsule

                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 12)
                                                .background {
                                                    Capsule()
                                                        .fill(Color.lemon)
                                                }
                                                .onLongPressGesture {
                                                    showMinutesPopover.toggle()
                                                }
                                                .popover(isPresented: $showMinutesPopover) {
                                                    PopoverContentView(maxValue: 60, minValue: 0, step: 5) { value in
                                                        minutes = value
                                                        showMinutesPopover = false
                                                        calculateDays()
                                                    }
                                                    .onDisappear {
                                                        calculateDays()
                                                    }
                                                }
                                            Text("min")
                                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                                .font(.custom("Montserrat-Bold", size: props.customFontSize.mediumLarge))
                                                .frame(width: 70, alignment: .leading)

                                            Spacer()

                                        }
                                    }
                        .onAppear{
                            calculateDays()
                        }
                        Spacer()
                        
                        HStack {
                            Spacer()

                            Button(action: {
                                showView6 = true
                            }) {
                                HStack {
                                    ArrowButtonView()
                                        .padding(.top, 40)
                                        .padding(.bottom, 20)
                                }
                            }.onAppear {
                                self.saveMaxUnProdST()
                            }
                            Spacer()

                        }
                        
                    }
                }
                .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 750)
                .background(
                    RoundedRectangle(cornerRadius: props.round.sheet)
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                )
                .rotatingBorder()
                
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
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

    private func saveMaxUnProdST() {
        let totalMinutes = (hours * 60) + (minutes)
        userSettings.maxUnProdST = totalMinutes
    }
    
    private func calculateDays() {
        let currentST = userSettings.unProdST
        var currentHour = 0
        let components = currentST.split(separator: " ")
        
        // Extra the user's current ST
        if components.count > 0 {
            // Further split the numeric part by the hyphen to get the individual digits
            let rangeComponents = components[0].split(separator: "-")
            if rangeComponents.count == 2 {
                // Extract the second digit
                currentHour = Int(rangeComponents[1]) ?? 0
                print("Second digit: \(currentHour)")
                
            }
        }
        // Total Screen Time to be reduced
        let totalMinutes = (hours * 60) + (minutes)
        let toReduce = (currentHour * 60) - totalMinutes
        if toReduce <= 0 {
            weeks = 0
            days = 0
        }else{
            let totalDays = (toReduce / 30) * 3
            weeks = Int(totalDays/7)
            days = totalDays - (weeks * 7)
        }
    }
}



//#Preview {
//    Onboarding5View()
//        .environmentObject(UserSettings())
//}
