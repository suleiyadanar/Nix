import SwiftUI

struct Onboarding5View: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 30
    @State private var showHoursPopover = false
    @State private var showMinutesPopover = false
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack {
                OnboardingProgressBarView(currentPage: 4)
                    .padding(.bottom, 25)
                
                HStack {
                    Text("Maximum limit for unproductive Screen Time?")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Spacer()
                }
                
                HStack {
                    Text("Unproductive Screen Time = ST spent other than for school, work, self care, etc.")
                        .foregroundColor(Color.sky)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                
                VStack(spacing: 40) {
                    HStack {
                        HStack {
                            Text("\(hours)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
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
                                }
                            Text("hr")
                                .font(.largeTitle)
                        }
                        .offset(x: -12)
                    }
                    
                    VStack {
                        HStack {
                            Text("\(minutes)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
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
                                    }
                                }
                            Text("min")
                                .font(.largeTitle)
                        }
                    }
                }
                .padding(.vertical, 20)
                
                NavigationLink(destination: Onboarding6View().onAppear {
                    self.saveMaxUnProdST()
                }) {
                    HStack {
                        ArrowButtonView()
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    private func saveMaxUnProdST() {
        let totalMinutes = (hours * 60) + (minutes)
        userSettings.maxUnProdST = totalMinutes
    }
}



#Preview {
    Onboarding5View()
        .environmentObject(UserSettings())
}
