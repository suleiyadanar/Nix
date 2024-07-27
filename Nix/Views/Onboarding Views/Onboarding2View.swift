import SwiftUI

struct Onboarding2View: View {
    var props: Properties
    
    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            EmbeddedNavigationView(props: props).frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .navigationBarHidden(true)
    }
}

struct NameRectangleView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.colorScheme) var colorScheme

    var props: Properties
    
    var body: some View {
        ZStack {
            let rectangleWidth = props.isIPad ? CGFloat(props.width) * 0.6 : CGFloat(props.width) * 0.8
            let rectangleHeight = props.isIPad ? CGFloat(60) : CGFloat(50)
            let cornerRadius = CGFloat(props.round.item)
            let fontSize = CGFloat(props.customFontSize.medium)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                .frame(width: rectangleWidth, height: rectangleHeight)
            
            TextField("Your name...", text: $userSettings.name)
                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(.leading, 15)
                            .frame(width: rectangleWidth, height: rectangleHeight)
                            .onChange(of: userSettings.name) { newValue in
                                userSettings.name = newValue.filter { $0.isLetter }
                                
            }
        }
    }
}

struct EmbeddedNavigationView: View {
    var props: Properties
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.colorScheme) var colorScheme

    @State private var showView3 = false
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 20)
            VStack(spacing: 20) {
                if showView3 {
                    Onboarding3View(props: props, showCurrView: $showView3)
                } else {
                    VStack(alignment: .center, spacing: 0) {
                        OnboardingProgressBarView(currentPage: 1)
                            .padding(.bottom, 25)
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Hi, what should we call you?")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                .fontWeight(.bold)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)

                            
                            Text("Creating a personalized journey for you...")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(.sky)
                                .padding(.bottom, 35)
                                .padding(.leading, props.isIPad ? 100 : 20)
                                .padding(.trailing, props.isIPad ? 100 : 10)

                            
                            
                            NameRectangleView(props: props)
                                .padding(.leading, props.isIPad ? 100 : 20)
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    showView3 = true
                                }) {
                                    if !userSettings.name.isEmpty {
                                        ArrowButtonView(props:props)
                                            .padding(.top, 40)
                                            .padding(.bottom, 20)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(width: props.width * 0.9)
                   
                        
                    }
                    
                    .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 750)
                    .background(
                        RoundedRectangle(cornerRadius: props.round.sheet)
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                    )
                    .rotatingBorder(props: props)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer(minLength: 20)
        }
        
        .scrollDisabled(true)
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// Helper function to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
