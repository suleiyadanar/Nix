import SwiftUI

struct RemainingScreenTimeView: View {
    let remainingScreenTime: String
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    // Computed property for parsed time details
    private var timeLines: [String] {
        parseRemainingScreenTime(remainingScreenTime)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let widthToCalculate = min(geometry.size.width, geometry.size.height)
            let fontSizeMessage = self.fontSizeMessage(for: widthToCalculate)
            let fontSizeTime = self.fontSizeTime(for: widthToCalculate)
            let team = userDefaults?.string(forKey: "team") ?? "water"

            let components = remainingScreenTime.split(separator: "\n").map(String.init)
            let header = components.first ?? ""

            HStack {
                Spacer() // Push content to the right
                VStack(alignment: .trailing, spacing: 4) { // Adjust spacing as needed
                    Text(header)
//                        .foregroundColor(header.contains("Exceeding") ? .red : .babyBlue)
                        .foregroundColor(.black)
                        .font(.custom("Montserrat-Bold", size: fontSizeMessage))
                        .frame(maxWidth: .infinity, alignment: .trailing) // Right align header
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        ForEach(timeLines, id: \.self) { line in
                            Text(line)
                                .foregroundColor(Color.teamColor(for: team, type: .secondary))
                                .font(.custom("Montserrat-Bold", size: fontSizeTime))
                                .frame(maxWidth: .infinity, alignment: .trailing) // Right align each line
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true) // Ensures vertical size is based on content
                .padding(0) // Remove padding to avoid extra space
            }
        }
    }
    
    private func parseRemainingScreenTime(_ text: String) -> [String] {
        let components = text.split(separator: "\n").map(String.init)
        let header = components.first ?? ""
        let timeDetails = components.count > 1 ? components[1] : ""
        
        // Create lines for hours and minutes based on the timeDetails format
        let timeComponents = timeDetails.split(separator: " ")
        if timeComponents.count >= 4 {
            // Expected format with hours and minutes
            let hours = timeComponents[0] // First part (hours)
            let minutes = timeComponents[2] // Third part (minutes)
            return ["\(hours) hours", "\(minutes) min"]
        } else {
            // Expected format with only minutes
            return [timeDetails] // Just the minutes part
        }
    }
    
    private func fontSizeMessage(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<700:
            return 18
        case 700..<1000:
            return 22
        case 1000...:
            return 28
        default:
            return 20
        }
    }
    
    private func fontSizeTime(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<700:
            return 23
        case 700..<1000:
            return 26
        case 1000...:
            return 35
        default:
            return 23
        }
    }
}

//#Preview {
//    RemainingScreenTimeView(remainingScreenTime: "Exceeding:\n3 hours 17 min")
//}
