import SwiftUI

struct SuggestRow: View {
    var title: String
    var time: String
    var appsBlocked: Int
    var color: Color
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(title)
                    .padding(.bottom, 2)
                Spacer()
                
//                Button(action: {
//                    // Add action
//                }) {
//                    Image(systemName: "plus")
//                        .font(.headline)
//                        .foregroundColor(.lemon)
//                }
            }
            
//            // Conditional Spacer based on device type
//            if horizontalSizeClass == .compact { // Compact size class (e.g., phone)
//                Spacer(minLength: 10)
//            } else {
                Spacer(minLength: 35)
//            }
            
            VStack(alignment: .leading) {
                Image(systemName: "clock")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .frame(minHeight: 100, maxHeight: 100)
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .safeAreaInset(edge: .trailing) {
            Color.clear.frame(width: 0)
        }
    }
}

struct SuggestRow_Previews: PreviewProvider {
    static var previews: some View {
        SuggestRow(title: "Club Meeting", time: "7:00pm - 8:00pm", appsBlocked: 3, color: .blue)
    }
}
