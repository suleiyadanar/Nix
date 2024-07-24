import SwiftUI

import SwiftUI

struct Onboarding1View: View {
    var props: Properties
    @State private var animateGradient: Bool = false
    @State private var info: [Info] = message
    @State private var activeIndex: Int = 0
    @State private var textOpacity: Double = 1.0
    @State private var fadeDuration: Double = 2.0
    @State private var animationTimer: Timer? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.babyBlue, .lightYellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                    .hueRotation(.degrees(animateGradient ? 35 : 0))
                    .onAppear {
                        startGradientAnimation()
                    }
                    .onDisappear {
                        animateGradient = false
                        stopTextAnimation() // Stop text animation when view disappears
                    }

                VStack {
                    Image("vector")
                        .padding(.top, 50)
                    Image("vector")
                        .padding(.top, 20)
                    Image("vector")
                        .padding(.top, 20)
                    Image("vector")
                        .padding(.top, 20)
                    Spacer()
                }

                VStack {
                    Text(" ───── Welcome to Nix  ───── ")
                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                        .foregroundColor(.white)
                        .shadow(color: .blue, radius: 0.2)
                        .padding(.top, 80)
                        .padding(.bottom, 15)
                    VStack(spacing: 15) {
                        Text("Elevating")
                            .font(.custom("Bungee-Regular", size: props.customFontSize.extraLarge))
                            .foregroundStyle(.white)
                            .lineSpacing(10)
                            .padding(.horizontal)
                        
                        Text("Your")
                            .font(.custom("Bungee-Regular", size: props.customFontSize.extraLarge))
                            .foregroundStyle(.white)
                            .lineSpacing(10)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.sky)
                            )

                        Text(info[activeIndex].text)
                            .font(.custom("Montserrat-Bold", size: props.isIPad ? props.customFontSize.large : props.customFontSize.mediumLarge))
                            .foregroundColor(Color.white.opacity(textOpacity))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                            .padding(.horizontal)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: fadeDuration), value: textOpacity)
                            .textCase(.uppercase)
                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .onAppear {
                        // Restart text animation when view appears
                        startTextAnimation()
                    }
                    .onDisappear {
                        // Pause text animation when view disappears
                        stopTextAnimation()
                    }
                    Spacer()
                    Image("mascot-fox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .offset(y: -30)

                    Text("☆ We're rooting for you! ☆")
                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                        .foregroundColor(Color.black)

                    Spacer()
                    VStack {
                        NavigationLink(destination: Onboarding2View(props: props).navigationBarHidden(true).navigationBarBackButtonHidden(true)) {
                            ButtonView(props: props, text: "Get Started")
                        }
                        HStack {
                            Text("Already a member?")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(Color.black)
                            NavigationLink("Login", destination: LoginView(props: props))
                                .font(.custom("Montserrat-Bold", size: props.customFontSize.smallMedium))
                                .foregroundColor(Color.sky)
                                .textCase(.uppercase)
                        }
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                .navigationBarHidden(true)
            }
        }
    }

    func startGradientAnimation() {
        // Restart the gradient animation
        animateGradient = true
        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            animateGradient.toggle()
        }
    }

    func startTextAnimation() {
        animationTimer?.invalidate() // Invalidate any existing timer
        animationTimer = Timer.scheduledTimer(withTimeInterval: fadeDuration * 2, repeats: true) { _ in
            withAnimation(.easeInOut(duration: self.fadeDuration)) {
                self.textOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.fadeDuration) {
                self.activeIndex = (self.activeIndex + 1) % self.info.count
                withAnimation(.easeInOut(duration: self.fadeDuration)) {
                    self.textOpacity = 1.0
                }
            }
        }
    }

    func stopTextAnimation() {
        animationTimer?.invalidate() // Stop the timer
        // Optionally reset text opacity to initial state if needed
        textOpacity = 1.0
    }
}

struct Info: Identifiable {
    var id = UUID()
    var text: String
}

let message: [Info] = [
    Info(text: "College Journey"),
    Info(text: "Academics"),
    Info(text: "Relationships"),
    Info(text: "Growth"),
    Info(text: "Career")
]

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
