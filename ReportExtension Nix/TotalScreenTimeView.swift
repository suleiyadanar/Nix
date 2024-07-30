import SwiftUI

struct TotalScreenTimeView: View {
    let totalScreenTime: String
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
    
    private var formattedTime: (hours: String, minutes: String) {
        let components = totalScreenTime.split(separator: "\n")
        let hoursPart = components.first?.split(separator: " ").first ?? "0"
        let minutesPart = components.last?.split(separator: " ").first ?? "0"
        
        // If you want two digits change here
        let hours = String(Int(hoursPart) ?? 0)
        let minutes = String(Int(minutesPart) ?? 0)
        
        return (hours, minutes)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let widthToCalculate = min(geometry.size.width, geometry.size.height)
            let fontSize = self.fontSize(for: widthToCalculate)
            let team = userDefaults?.string(forKey: "team") ?? "water"
            withAnimation(.easeInOut(duration: 0.5)) {
                
                ZStack(alignment: .leading) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 10) {
                            Text(formattedTime.hours)
                                .font(.custom("Aldrich-Regular", size: fontSize))
                                .shadow(color: .black, radius: 0.4)
                                .shadow(color: .black, radius: 0.4)
                                .shadow(color: .black, radius: 0.4)
                                .shadow(color: .black, radius: 0.4)
                            
                            
                            Text("hr")
                                .foregroundColor(.black)
                                .font(.custom("Aldrich-Regular", size: fontSize * 0.6))
                                .frame(alignment:.trailing)

                               
                            
                        }
                        HStack(spacing: 10) {
                            Text(formattedTime.minutes)
                                .font(.custom("Aldrich-Regular", size: fontSize))
                                .shadow(color: .black, radius: 0.4)
                                .shadow(color: .black, radius: 0.4)
                                .shadow(color: .black, radius: 0.4)
                                .shadow(color: .black, radius: 0.4)

                            Text("min")
                                .foregroundColor(.black)
                                .font(.custom("Aldrich-Regular", size: fontSize * 0.6))
                                .frame(alignment:.trailing)
                            
                        }
                    }
                    .foregroundColor(Color.teamColor(for: team, type: .secondary))
                    .fixedSize(horizontal: true, vertical: true)
                    .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
    }

    private func fontSize(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<100:
            return 35
        case 100..<250:
            return 60
        case 250..<405:
            return 75
        default:
            return 35
        }
    }
}
