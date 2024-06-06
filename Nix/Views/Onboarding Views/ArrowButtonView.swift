import SwiftUI

struct ArrowButtonView: View {
    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.lemon)
                .offset(x: 3, y: 5)
            
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
