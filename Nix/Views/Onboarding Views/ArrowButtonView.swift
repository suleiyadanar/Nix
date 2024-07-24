import SwiftUI

struct ArrowButtonView: View {
    @State private var pulsate = false

    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.lemon.opacity(0.5))
                .scaleEffect(pulsate ? 1.3 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(0.5),
                    value: pulsate
                )
                .onAppear {
                    pulsate.toggle()
                }
            
            // Button layer
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.lav.opacity(0.9))
                .strokeBorder(Color.mauve, lineWidth: 2)
                .overlay(
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                )

        }
        
        .frame(width: 50, height: 35)
    }
    
}

#Preview {
    ArrowButtonView()
}
