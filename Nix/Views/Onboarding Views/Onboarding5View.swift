import SwiftUI

struct Onboarding5View: View {
    @Environment(\.colorScheme) var colorScheme
    var props: Properties
    @Binding var showCurrView: Bool

    @State private var hours: Int = 0
    @State private var minutes: Int = 30


    @State private var showHoursPopover = false
    @State private var showMinutesPopover = false
    @State private var showDaysPopup = false
    @EnvironmentObject var userSettings: UserSettings

    @State private var showView6 = false

    var body: some View {
        ScrollView {
            VStack {
                if showView6 {
                    Onboarding6View(props: props, showCurrView: $showView6)
                } else {
                    ZStack {
                        VStack(alignment: .center, spacing: 0) {
                            OnboardingProgressBarView(currentPage: 4)
                                .padding(.bottom, 25)

                            VStack(alignment: .leading, spacing: 20) {
                                Text("Maximum limit for unproductive Screen Time Per Day?")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                    .padding(.horizontal, props.isIPad ? 100 : 20)

                                Text("Unproductive Screen Time =\nST spent other than for school, work, self care, etc.")
                                    .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                    .foregroundColor(.sky)
                                    .padding(.bottom, props.isIPad ? 35 : 30)
                                    .padding(.horizontal, props.isIPad ? 100 : 20)

                                if props.isIPad {
                                    Spacer()
                                }

                                VStack(alignment: .leading, spacing: 40) {
                                    TimeSelectionView(props: props, title: "hr", value: $hours, showPopover: $showHoursPopover, items: Array(0...3), columns: 2)
                                    TimeSelectionView(props: props, title: "min", value: $minutes, showPopover: $showMinutesPopover, items: Array(stride(from: 0, through: 59, by: 15)), columns: 2)
                                }
                                .onAppear {
                                    calculateDays()
                                }

                                Spacer()

                                HStack {
                                    Spacer()

                                    Button(action: {
                                        saveMaxUnProdST()
                                        calculateDays()
                                        showView6 = true
                                    }) {
                                        HStack {
                                            ArrowButtonView(props: props)
                                                .padding(.top, 40)
                                                .padding(.bottom, 20)
                                        }
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
                        .rotatingBorder(props: props)

                        // Pop-up for hours selection
                        if showHoursPopover {
                            CustomPopupView(
                                props: props,
                                items: Array(0...3),
                                columns: 2,
                                onSelect: { value in
                                    hours = value
                                    showHoursPopover = false
                                },
                                isVisible: $showHoursPopover
                            )
                            .transition(.opacity)
                        }

                        // Pop-up for minutes selection
                        if showMinutesPopover {
                            CustomPopupView(
                                props: props,
                                items: Array(stride(from: 0, through: 59, by: 15)),
                                columns: 2,
                                onSelect: { value in
                                    minutes = value
                                    showMinutesPopover = false
                                },
                                isVisible: $showMinutesPopover
                            )
                            .transition(.opacity)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Spacer(minLength: 20)
        }
        .scrollDisabled(true)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        showCurrView = false
                    }
                }
        )
    }

    private func saveMaxUnProdST() {
        let totalMinutes = (hours * 60) + (minutes)
        userSettings.maxUnProdST = totalMinutes
        print("saved maxUnProdST, \(userSettings.maxUnProdST)")
    }

    private func calculateDays() {
        let currentST = userSettings.unProdST
        var currentHour = 0

        let components = currentST.split(separator: " ")

        if components.count > 0 {
            let rangeComponents = components[0].split(separator: "-")
            if rangeComponents.count == 2 {
                currentHour = Int(rangeComponents[1]) ?? 0
            } else if rangeComponents.count == 1 && rangeComponents[0] == "7+" {
                currentHour = 7
                print("current hour supposed to be 7")
            }
        }

        let totalMinutes = (hours * 60) + (minutes)
        let toReduce = (currentHour * 60) - totalMinutes
        print("\(toReduce)")

        if toReduce <= 0 {
           
        } else {
            let cycleCount = (toReduce + 29) / 30
            print("cycleCount,\(cycleCount)")
            let totalDays = cycleCount * 3
            print("totalDays saved in user settings: \(totalDays) days")
            userSettings.totalDays = totalDays
        }
    }
}

struct TimeSelectionView: View {
    @Environment(\.colorScheme) var colorScheme

    var props: Properties
    var title: String
    @Binding var value: Int
    @Binding var showPopover: Bool
    var items: [Int]
    var columns: Int

    var body: some View {
        HStack {
            Spacer()
            Text("\(value)")
                .foregroundColor(.black)
                .font(.custom("Montserrat-Bold", size: 18))
                .frame(width: 50)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Capsule().fill(Color.lemon))
                .onTapGesture {
                    showPopover.toggle()
                }
            Text(title)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .font(.custom("Montserrat-Bold", size: 18))
                .frame(width: 70, alignment: .leading)
            Spacer()
        }
    }
}
