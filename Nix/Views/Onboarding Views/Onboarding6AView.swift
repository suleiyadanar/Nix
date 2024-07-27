import SwiftUI

struct Onboarding6AView: View {
    var props: Properties

    @Binding var weeks: Int
    @Binding var days: Int
    @Environment(\.colorScheme) var colorScheme

    @Environment(\.presentationMode) var presentationMode
    @State private var showWeeksPopup = false
    @State private var showDaysPopup = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Text("The suggested time frame is \(weeks) weeks and \(days) days, but we trust your judgement. You can always change it back in the settings.")
                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                        .foregroundColor(.sky)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Spacer()
                }
               
                
                HStack(spacing: 40) {
                    Button(action: {
                        showDaysPopup.toggle()
                    }) {
                        Text("\(String(format: "%02d", weeks * 7 + days))")
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.black)
                            .font(.custom("Montserrat-Bold", size: props.customFontSize.mediumLarge))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .frame(width: 100) // Fixed width for the capsule
                            .background {
                                Capsule()
                                    .fill(Color.yellow)
                            }
                    }
                    Text("days")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .font(.custom("Montserrat-Bold", size: props.customFontSize.medium))
                        .frame(width: 80, alignment: .leading)
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
            .background(colorScheme == .dark ? Color.black : Color.white)
            .edgesIgnoringSafeArea(.all)
            
            // Weeks Popup
          
                        
                        // Days Popup
                        if showDaysPopup {
                            CustomPopupView(
                                props: props,
                                items: Array(stride(from: 3, through: 84, by: 3)),
                                columns: 3,
                                onSelect: { value in
                                    weeks = value / 7
                                    days = value % 7
                                    showDaysPopup = false
                                },
                                isVisible: $showDaysPopup
                                
                            )
                        }
        }
    }
}

struct CustomPopupView: View {
    var props: Properties
    let items: [Int]
        let columns: Int
        let onSelect: (Int) -> Void
    @Binding var isVisible: Bool

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                ScrollView{
                    ForEach(Array(items.chunked(into: columns)), id: \.self) { row in
                                        HStack {
                                            ForEach(row, id: \.self) { item in
                                                Button(action: {
                                                    onSelect(item)
                                                }) {
                                                    Text("\(item)")

                                                        .padding()
                                                        .font(.custom("Montserrat-Bold", size: props.customFontSize.medium))
                                                        .foregroundColor(Color.black)
                                                        .frame(maxWidth: .infinity)
                                                        .background(Capsule().fill(Color.yellow))
                                                }
                                            }
                                        }
                                    }
                }.scrollIndicators(.hidden)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            .frame(maxWidth: 300)
            
            Button(action: {
                isVisible = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.lightGray)
                    .font(.largeTitle)
                    .padding()
            }
        }
        .frame(height: props.isIPad ? 250 : 300)
        .padding()
        .background(Color.black.opacity(0.2).edgesIgnoringSafeArea(.all))
        .cornerRadius(20)
        .onTapGesture {
            isVisible = false
        }
    }
}
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for index in stride(from: 0, to: count, by: size) {
            let chunk = Array(self[index..<Swift.min(index + size, count)])
            chunks.append(chunk)
        }
        return chunks
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

//Text("\(value)")
//    .font(.custom("Montserrat-Bold", size: props.customFontSize.medium))
//    .foregroundColor(.black)
//    .padding()
//    .frame(maxWidth: .infinity)
//    .background(Capsule().fill(Color.lemon))
