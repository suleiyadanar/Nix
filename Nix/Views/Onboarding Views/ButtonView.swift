import SwiftUI

struct ButtonView: View {
    var props: Properties
    let text: String

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.lemon)
                .offset(x: 5, y: 7)
            
            // Button layer with rotating gradient border
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.lav.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.mauve, .lav, .mauve]),
                                center: .center,
                                startAngle: .degrees(rotation),
                                endAngle: .degrees(rotation + 360)
                            ),
                            lineWidth: 4
                        )
                )

            Text(text)
                .font(.custom("Bungee-Regular", size: props.customFontSize.mediumLarge))
                .foregroundColor(.white)
                .padding()
                .textCase(.uppercase)
        }
        .frame(width: props.isIPad ? 300 : 250, height: props.isIPad ? 80 : 60)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
        .onAppear {
            withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}



//#Preview {
//    ButtonView(text: "")
//}
