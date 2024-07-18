import SwiftUI

struct TimeOutSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDelay: String = "None"
    @State private var selectedLength: String = "1 min"
    @State private var selectedMethod: String = "Math Problems"
    
    var body: some View {
        
        VStack (alignment: .leading){
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("timeout-back-button")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
                
                Text("Time Out")
                    .font(.system(size: 30))
    
            }
            .padding(10)
            .padding(.top, 15)
            
            HStack {
                Text("Time Out Allowed")
                    .font(.system(size: 15))
                
                Spacer(minLength: 35)
                
                HStack {
                    Button(action: {
                        // Action for Time Out Allowed
                    }) {
                        Image(systemName: "infinity")
                            .padding(10)
                            .background(Color.lemon)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 10)
            }
            
            Text("Delay between Time Outs")
                .font(.headline)
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    TimeOutButton(title: "None", selected: $selectedDelay)
                    TimeOutButton(title: "5 mins", selected: $selectedDelay)
                    TimeOutButton(title: "15 mins", selected: $selectedDelay)
                    TimeOutButton(title: "30 mins", selected: $selectedDelay)
                    TimeOutButton(title: "1 hour", selected: $selectedDelay)
                }
            }
            .padding(.vertical, 10)
            .offset(y: -5)
            
            Text("Length of Time Outs")
                .font(.headline)
            
            HStack(spacing: 10) {
                TimeOutButton(title: "1 min", selected: $selectedLength)
                TimeOutButton(title: "5 mins", selected: $selectedLength)
                TimeOutButton(title: "15 mins", selected: $selectedLength)
                TimeOutButton(title: "30 mins", selected: $selectedLength)
                TimeOutButton(title: "1 hour", selected: $selectedLength)
            }
            .padding(.vertical, 10)
            .offset(y: -5)
            
            Text("Unlock Method")
                .font(.headline)
            
            HStack(spacing: 10) {
                UnlockMethodButton(title: "Math Problems", selected: $selectedMethod)
                UnlockMethodButton(title: "Entry Prompt", selected: $selectedMethod)
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    // Save action
                }) {
                    SaveButtonView()
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .padding(5)
        .navigationBarBackButtonHidden(true)
    }
}

struct TimeOutButton: View {
    var title: String
    @Binding var selected: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(selected == title ? Color.lemon : Color.gray.opacity(0.4))
                .frame(width: 60, height: 30)
                .cornerRadius(15)
            
            Button(action: {
                selected = title
            }) {
                Text(title)
                    .foregroundColor(selected == title ? .black : .white)
                    .font(.system(size:14))
                    .padding(.horizontal, 5) // Adjusted padding to ensure text fits
                    .frame(maxWidth: 60, maxHeight: 30)
                    .background(Color.clear)
                    .cornerRadius(15)
            }
        }
    }
}

struct UnlockMethodButton: View {
    var title: String
    @Binding var selected: String
    
    var body: some View {
        Button(action: {
            selected = title
        }) {
            Text(title)
                .padding(.horizontal, 5)
                .padding(10)
                .font(.system(size: 14))
                .background(selected == title ? Color.lemon : Color.gray.opacity(0.4))
                .cornerRadius(15)
                .foregroundColor(selected == title ? .black : .white)
        }
    }
}

#Preview {
    TimeOutSettingsView()
}
