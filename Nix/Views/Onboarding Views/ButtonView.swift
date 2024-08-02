import SwiftUI

struct ButtonView: View {
    var props: Properties
    let text: String
    let imageName: String?
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.lemon)
                .offset(x: 5, y: 7)
            
            // Button layer with rotating gradient border
            RoundedRectangle(cornerRadius: props.round.item)
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
            HStack {
                Text(text)
                    .font(.custom("Bungee-Regular", size: !props.isIPad || props.isSplit ? props.customFontSize.medium : props.customFontSize.mediumLarge))
                    .foregroundColor(.white)
                    .padding()
                    .textCase(.uppercase)
                if let imageName = imageName {
                    Image(imageName)
                }
            }
          
        }
        .frame(width: !props.isIPad || props.isSplit ? props.width * 0.5 : props.width * 0.4, height: props.isIPad ? 60 : 50)
        .padding(.horizontal, !props.isIPad || props.isSplit ? 20 : 40)
        .padding(.bottom, 14)
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
