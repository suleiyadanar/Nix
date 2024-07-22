import SwiftUI

struct Onboarding2View: View {
    var props: Properties
    
    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            EmbeddedNavigationView(props:props)
        }
        .navigationBarHidden(true)
    }
}

struct NameRectangleView: View {
    @EnvironmentObject var userSettings: UserSettings
    var props: Properties
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: props.round.item)
                .foregroundColor(Color.black.opacity(0.06))
                .frame(width: 300, height: 100)
            
            TextField("Your name...", text: $userSettings.name)
                .font(.custom("Nunito-Medium", size: props.customFontSize.medium))
                .foregroundColor(.black)
                .padding(.leading, 15)
                .frame(width: 300, height: 100)
        }
    }
}


struct EmbeddedNavigationView: View {
    var props: Properties
    @EnvironmentObject var userSettings: UserSettings

    @State private var showView3 = false

    var body: some View {
     

        ScrollView {
            Spacer(minLength:20)
            VStack {
                if showView3 {
                    Onboarding3View(props: props, showCurrView: $showView3)
                } else {
                    VStack(spacing: 0) {
                        VStack(spacing: 20) {
                            OnboardingProgressBarView(currentPage: 1)
                                .padding(.bottom, 25)
                            
                            Text("Hi, what should we call you?")
                                .foregroundColor(.black)
                                .font(.custom("Nunito-Medium", size: props.customFontSize.mediumLarge))
                                .fontWeight(.bold)
                            
                            Text("Creating a personalized journey for you...")
                                .font(.custom("Nunito-Medium", size: props.customFontSize.medium))
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                                .padding(.bottom, 20)
                            
//                            Spacer() // Pushes content towards the center
                            
                            NameRectangleView(props: props)
                                .padding(.top, 15)
                            
                            Spacer() // Pushes content towards the center
                            
                            Button(action: {
                                showView3 = true
                            }) {
                                if !userSettings.name.isEmpty {
                                    ArrowButtonView()
                                        .padding(.top, 40)
                                        .padding(.bottom, 20) // Adjust as needed
                                }
                            }
                        }
                        .padding()
                        .frame(height:1000)
                        .background(
                            RoundedRectangle(cornerRadius: props.round.sheet)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                    }
                    .frame(height: 1000) // Set a fixed height for the embedded view
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2)) // Optional: add a background to distinguish the frame
            Spacer(minLength: 20)
        }.scrollDisabled(true)

    }
}


struct DetailView: View {
    var body: some View {
        VStack {
            Text("This is the detail view")
            Button(action: {
                // Action to go back if needed
            }) {
                Text("Go Back")
            }
            .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
