import SwiftUI

struct Onboarding2View: View {
    @EnvironmentObject var userSettings: UserSettings
    var props: Properties
    
    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            
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
                    
                    NameRectangleView(props: props)
                        .padding(.top, 15)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    NavigationLink(destination: Onboarding3View(props: props)) {
                        if !userSettings.name.isEmpty {
                            ArrowButtonView()
                                .padding(.top, 40)
                                .padding(.bottom, 20) // Adjust as needed
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: props.round.sheet)
                        .fill(Color.white)
                )
                .padding(.horizontal) // Add padding here if needed
                
                Spacer()
            }
            .padding(.top, 40) // Adjust as needed
        }
        .ignoresSafeArea(.keyboard) // Ensures the keyboard floats over the view
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
                .frame(width: props.onBoarding.textBoxWidth, height: props.onBoarding.textBoxHeight)
            
            TextField("Your name...", text: $userSettings.name)
                .font(.custom("Nunito-Medium", size: props.customFontSize.medium))
                .foregroundColor(.black)
                .padding(.leading, 15)
                .frame(maxWidth: .infinity)
        }
    }
}
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
