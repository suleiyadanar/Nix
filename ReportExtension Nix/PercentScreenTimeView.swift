import SwiftUI

struct PercentScreenTimeView: View {
    let percentScreenTime: String
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    var body: some View {
        GeometryReader { geometry in
            let widthToCalculate = min(geometry.size.width, geometry.size.height)
            let fontSizePercent = self.fontSizePercent(for: widthToCalculate)
            let progress = self.progressValue(from: percentScreenTime)
            let segmentCount = 10
            let segmentLineWidth: CGFloat = geometry.size.width > 200 ? 15 : 10
            let segmentSpacing: CGFloat = 5 // Space between segments in degrees
            let borderLineWidth: CGFloat = 3 // Width of the black border

            ZStack {
                ForEach(0..<segmentCount) { index in
                    // Calculate the adjusted angle for the segments
                    let segmentAngle = 360.0 / Double(segmentCount)
                    let startAngle = Angle(degrees: segmentAngle * Double(index) + segmentSpacing / 2)
                    let endAngle = Angle(degrees: segmentAngle * Double(index + 1) - segmentSpacing / 2)
                    let isFilled = Double(index + 1) / Double(segmentCount) <= progress
                    let team = userDefaults?.string(forKey: "team") ?? "water"

                    // Draw the border with square ends and spacing
                    Arc(startAngle: startAngle, endAngle: endAngle)
                        .stroke(style: StrokeStyle(lineWidth: segmentLineWidth + borderLineWidth, lineCap: .butt))
                        .foregroundColor(isFilled ? Color.black : Color.clear)
                    
                    // Draw the main segment with square ends and spacing
                    Arc(startAngle: startAngle, endAngle: endAngle)
                        .stroke(style: StrokeStyle(lineWidth: segmentLineWidth, lineCap: .butt))
                        .foregroundColor(isFilled ? Color.teamColor(for: team, type: .primary) : Color.teamColor(for: team, type: .accent).opacity(0.3))
                }
                .rotationEffect(.degrees(-90)) // Rotate segments to start from the top
                
                Text(percentScreenTime)
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-Bold", size: fontSizePercent))
                    .rotationEffect(.degrees(0)) // Keep the text upright
                
            }.frame(width: widthToCalculate, height: widthToCalculate, alignment: .topTrailing)
            .offset(x: geometry.size.width - widthToCalculate, y: 0)
            
            
//            .background(Color.green)
        }
//        .padding()
//        .background(Color.yellow)
            

    }
    
    private func fontSizePercent(for width: CGFloat) -> CGFloat {
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
    
    private func progressValue(from percentScreenTime: String) -> Double {
        guard let percentage = Double(percentScreenTime.replacingOccurrences(of: "%", with: "")) else {
            return 0
        }
        return percentage / 100
    }
}

//struct Arc: Shape {
//    let startAngle: Angle
//    let endAngle: Angle
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        let radius = max(rect.width, rect.height) / 2.5
//        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        return path
//    }
//}

//#Preview {
//    PercentScreenTimeView(percentScreenTime: "75%")
//}
