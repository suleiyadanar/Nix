import SwiftUI

struct Onboarding1View: View {
    var props: Properties
    @State private var animateGradient: Bool = false
    @State private var info: [Info] = message
    @State private var activeIndex: Int = 0
    @State private var circleOffset: CGFloat = 0.0
    @State private var textOpacity: Double = 1.0
    @State private var isTyping = true
    @State private var currentText = ""
    private let typingSpeed: TimeInterval = 0.1

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.babyBlue, .lightYellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                    .hueRotation(.degrees(animateGradient ? 35 : 0))
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
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
                        .font(.custom("Montserrat-Regular", size: props.customFontSize.medium))
                        .foregroundColor(.white)
                        .shadow(color: .blue, radius: 0.2)
                        .padding(.top, 80)
                    Spacer()
                    VStack(spacing: 0) {
                        Text("Elevating Your")
                            .font(.custom("Montserrat-Regular", size: props.customFontSize.extraLarge))
                            .foregroundStyle(.white)
                            .lineSpacing(6)
                            .padding(.horizontal)

                        Text(currentText)
                            .font(.custom("Nunito-Medium", size: props.customFontSize.large))
                            .foregroundColor(Color.white.opacity(textOpacity))
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .padding(.horizontal)

                    }
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    .onAppear {
                        animateText()
                    }
                    Spacer()
                    Image("chick")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260, height: 260)
                        .offset(y: -30)

                    Text("☆ We're rooting for you! ☆")
                        .font(.custom("Montserrat-Regular", size: props.customFontSize.medium))
                        .foregroundColor(.mauve)

                    Spacer()
                    VStack {
                        NavigationLink(destination: Onboarding2View(props: props).navigationBarHidden(true).navigationBarBackButtonHidden(true)) {
                            ButtonView(props: props, text: "GET STARTED")
                        }
                        HStack {
                            Text("Already a member?")
                            NavigationLink("Login", destination: LoginView(props: props))
                        }
                    }
                    Spacer()

                }
                .ignoresSafeArea()
                .navigationBarHidden(true)
            }
            .onAppear {
                animate(0)
            }
        }
    }

    func animate(_ index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            activeIndex = index
            withAnimation(Animation.easeInOut(duration: 2)) {
                circleOffset = 0.0
                textOpacity = 1.0
            }
            animateText() // Start typing animation after other animations complete
        }
    }

    func animateText() {
        guard activeIndex < info.count else { return }
        var index = info[activeIndex].text.startIndex
        Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if isTyping {
                if index < info[activeIndex].text.endIndex {
                    currentText.append(info[activeIndex].text[index])
                    index = info[activeIndex].text.index(after: index)
                } else {
                    isTyping = false
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        // Start the ease out animation here
                        withAnimation(.easeOut(duration: 0.5)) {
                            textOpacity = 0.0 // Fade out the text
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            animateNextText()
                        }
                    }
                }
            } else {
                timer.invalidate()
            }
        }
    }

    func animateNextText() {
        // Reset textOpacity and prepare for the next text animation
        textOpacity = 1.0
        currentText = ""
        activeIndex = (activeIndex + 1) % info.count
        isTyping = true
        animateText() // Start typing animation for the next text
    }
}

struct Info: Identifiable {
    var id = UUID()
    var text: String
    var circleColor: Color
}

let message: [Info] = [
    Info(text: "Academic Success", circleColor: .red),
    Info(text: "College Journey", circleColor: .blue),
    Info(text: "Relationships", circleColor: .green),
    Info(text: "Personal Growth", circleColor: .purple),
    Info(text: "Career Development", circleColor: .orange)
]
