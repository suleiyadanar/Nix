import SwiftUI

struct Onboarding6AView: View {
    @Binding var weeks: Int
    @Binding var days: Int

    @Environment(\.presentationMode) var presentationMode
    @State private var showWeeksPopover = false
    @State private var showDaysPopover = false

    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("The suggested time frame is 8 weeks, but we trust your judgment. You can always change it back in the settings.")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.leading, 15)
                    .padding(.top, 20)
                Spacer()
            }
            
            HStack(spacing: 40) {
                Text("\(String(format: "%02d", weeks))")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(Color.yellow)
                    }
                    .onLongPressGesture {
                        showWeeksPopover.toggle()
                    }
                    .popover(isPresented: $showWeeksPopover) {
                        PopoverContentView(maxValue: 12, minValue: 0, step: 1) { value in
                            weeks = value
                            showWeeksPopover = false
                        }
                    }
                Text("weeks")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
            }
            
            HStack(spacing: 40) {
                Text("\(String(format: "%02d", days))")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(Color.yellow)
                    }
                    .onLongPressGesture {
                        showDaysPopover.toggle()
                    }
                    .popover(isPresented: $showDaysPopover) {
                        PopoverContentView(maxValue: 15, minValue: 3, step: 3) { value in
                            days = value
                            showDaysPopover = false
                        }
                    }
                Text("days")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 40)
        }
        .padding()
        .navigationBarHidden(true)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct PopoverContentView: View {
    let maxValue: Int
    let minValue: Int
    let step: Int
    let onSelect: (Int) -> Void

    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(stride(from: minValue, through: maxValue, by: step)), id: \.self) { value in
                    Button("\(value)") {
                        onSelect(value)
                    }
                    .padding()
                    .background(Capsule().fill(Color.yellow))
                }
            }
            .padding()
        }
        .frame(height: 200) // Limit the height of the popover
    }
}

//struct Onboarding6AView_Previews: PreviewProvider {
//    @State static var weeks: Int = 8
//    @State static var days: Int = 1
//
//    static var previews: some View {
//        Onboarding6AView(weeks: $weeks, days: $days)
//    }
//}
