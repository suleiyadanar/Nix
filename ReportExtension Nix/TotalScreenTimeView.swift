import SwiftUI

struct TotalScreenTimeView: View {
    let reportData: [TimeInterval]
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
    
    @State private var currentTimeIndex: Int? = nil
    @State private var selectedHourST: String = ""
    
    private var formattedTime: (hours: String, minutes: String) {
        let components = totalScreenTime(totalActivity: totalActivity(reportData: reportData)).split(separator: "\n")
        let hoursPart = components.first?.split(separator: " ").first ?? "0"
        let minutesPart = components.last?.split(separator: " ").first ?? "0"
        
        // If you want two digits change here
        let hours = String(Int(hoursPart) ?? 0)
        let minutes = String(Int(minutesPart) ?? 0)
        
        return (hours, minutes)
    }
    
    private func totalActivity(reportData: [TimeInterval]) -> TimeInterval {
        return reportData.reduce(0, { $0 + $1 * 60 })
    }
    
    private func totalScreenTime(totalActivity: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .pad
        
        let formattedString = formatter.string(from: totalActivity) ?? "No activity data"

        let formattedWithNewline = formattedString.replacingOccurrences(of: ", ", with: "\n")
        
        return formattedWithNewline
    }
    
    private func percentScreenTime(totalActivity: TimeInterval) -> String {
        let maxUnProdST = userDefaults?.integer(forKey: "maxUnProdST")

//        let percentTime = ((totalActivityDurationInMinutes - (maxUnProdST ?? 0)) / totalActivityDurationInMinutes) * 100
        let percentTime: Double
        let totalActivityDurationInMinutes = Int(totalActivity / 60)

        if totalActivityDurationInMinutes == 0 {
            percentTime = 0
        }
        else if maxUnProdST == totalActivityDurationInMinutes {
            percentTime = 100
        }
        else if let maxUnProdST = maxUnProdST, maxUnProdST != 0 {
            percentTime =  ((Double(maxUnProdST)-Double(totalActivityDurationInMinutes)) / Double(maxUnProdST)) * 100
        } else {
            percentTime = 100
        }
        
        // Determine if the time is remaining or exceeding
        var resultString: String
        if percentTime == 100 {
            resultString = "100%"
        }else if percentTime == 0{
            resultString = "0%"
        }else if percentTime > 0{
            resultString = String(format: "%.1f%%", 100-percentTime)
        }else{
            resultString = "100%"
        }
        
        return resultString
    }
    
    private func remainingScreenTime(totalActivity: TimeInterval) -> String {
        let totalActivityDurationInMinutes = Int(totalActivity / 60)
//        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
//        userDefaults?.set(500, forKey: "maxUnProdST")
        let maxUnProdST = userDefaults?.integer(forKey: "maxUnProdST")

        let remainingTime = (maxUnProdST ?? 0) - totalActivityDurationInMinutes

        // Determine if the time is remaining or exceeding
        let timeString: String
        if remainingTime >= 0 {
            let hours = Int(remainingTime / 60)
            let minutes = Int(remainingTime) % 60
            if hours > 0 {
                timeString = String(format: "Remaining\n%02d hr %02d min", hours, minutes)
            } else {
                timeString = String(format: "Remaining\n%02d min", minutes)
            }
        } else {
            let exceededTime = abs(remainingTime)
            let hours = Int(exceededTime / 60)
            let minutes = Int(exceededTime) % 60
            if hours > 0 {
                timeString = String(format: "Exceeding\n%02d hr %02d min", hours, minutes)
            } else {
                timeString = String(format: "Exceeding\n%02d min", minutes)
            }
        }
        return String(timeString)
    }
    private var timeLines: [String] {
        parseRemainingScreenTime(remainingScreenTime(totalActivity: totalActivity(reportData: reportData)))
    }

    
    var body: some View {
        GeometryReader { geometry in
            let totalActivity = totalActivity(reportData: reportData)
            let widthToCalculate = min(geometry.size.width, geometry.size.height)
            
            let fontSize = self.fontSize(for: widthToCalculate)
            let fontSizePercent = self.fontSizePercent(for: widthToCalculate)

            let team = userDefaults?.string(forKey: "team") ?? "water"
            
            
            let progress = self.progressValue(from: percentScreenTime(totalActivity: totalActivity))
            let segmentCount = 10
            let segmentLineWidth: CGFloat = geometry.size.width > 200 ? 15 : 10
            let segmentSpacing: CGFloat = 5 // Space between segments in degrees
            let borderLineWidth: CGFloat = 3 // Width of the black border
            
            let fontSizeMessage = self.fontSizeMessage(for: widthToCalculate / 3)
            let fontSizeTime = self.fontSizeTime(for: widthToCalculate / 3)

            let components = remainingScreenTime(totalActivity: totalActivity).split(separator: "\n").map(String.init)
            let header = components.first ?? ""
            
                    
            var completeData: [TimeInterval] {
                   // Preprocess data outside the view body if needed
                   return prepareData(reportData: reportData)
               }
            VStack(alignment: .leading) {
                HStack (alignment:.top) {
                    VStack(alignment: .leading){
                        Text("Today's Screen Time")
                            .foregroundColor(.black)
                            .font(.custom("Bungee-Regular", size: fontSize))
                            .fixedSize(horizontal: false, vertical: true) // Allow text to expand vertically
                            .padding(.top, 5)
                        withAnimation(.easeInOut(duration: 0.5)) {
                            
                            ZStack(alignment: .leading) {
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        HStack(spacing: 10) {
                                            Text(formattedTime.hours)
                                                .font(.custom("Aldrich-Regular", size: fontSize*2))
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
                                                .font(.custom("Aldrich-Regular", size: fontSize*2))
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
                                }
                                .foregroundColor(Color.teamColor(for: team, type: .secondary))
                                .fixedSize(horizontal: true, vertical: true)
                                .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.bottom, 15)
//
                    }
                    }
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10) {
                            // DeviceActivityReport for percentage
                            // HERE
                            ZStack {
                                ForEach(0..<segmentCount, id: \.self) { index in
                                    // Calculate the adjusted angle for the segments
                                    let segmentAngle = 360.0 / Double(segmentCount)
                                    let startAngle = Angle(degrees: segmentAngle * Double(index) + segmentSpacing / 2)
                                    let endAngle = Angle(degrees: segmentAngle * Double(index + 1) - segmentSpacing / 2)
                                    let isFilled = Double(index + 1) / Double(segmentCount) <= progress

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
                                
                                Text(percentScreenTime(totalActivity: totalActivity))
                                    .foregroundColor(.black)
                                    .font(.custom("Montserrat-Bold", size: fontSizePercent))
                                    .rotationEffect(.degrees(0)) // Keep the text upright
                                
                            }
                            .frame(width: widthToCalculate / 3, height: widthToCalculate / 3)
//                            .offset(x: widthToCalculate, y: 0)
                                
//                                        .frame(width: props.isIPad && !props.isSplit ? props.width * 0.15 : props.width * 0.25, height: props.height * 0.1, alignment: .topTrailing)
                            
                            
                            // DeviceActivityReport for remaining time
                            
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
                            } .padding(.trailing, 10)
                         
//                                        DeviceActivityReport(contextRemaining, filter: filterRemaining)
//                                            .frame(height: props.height * 0.1, alignment: .topTrailing)
                            }
                }
            }
                VStack(alignment: .leading) {
                    // Display the selected hour as title text
                    
                  
                    ScrollViewReader { scrollView in
                        HStack {
                            Text(selectedHourST)
                                .font(.custom("Montserrat-Bold", size: 12))
                                .foregroundColor(.black)
                            Spacer()
                            Button(action: {
                                let calendar = Calendar.current
                                let hour = calendar.component(.hour, from: Date())
                                let currentIndex = hour  // Calculate the current hour index
                                withAnimation {
                                    scrollView.scrollTo(currentIndex, anchor: .center) // Scroll to the calculated index
                                }
                            }) {
                                Text("Jump to Current")
                                    .font(.custom("Montserrat-Bold", size: 12))
                                    .padding()
                                    .background(Color.teamColor(for: team, type: .accent))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.bottom, 10)
                        }
                       
                        HStack(spacing: 10) {
                            YAxisView(maxValue: 60)
                                .frame(height: barHeight(for: 60))
                                .padding(.bottom, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                ZStack {
                                    TimeOfDayBackground()
                                        .frame(height: barHeight(for: 60+2))
                                        .padding(.bottom, 7)
                                        .foregroundColor(.black)
                                    
                                    HStack(spacing: 5) {
                                        ForEach(0..<24, id: \.self) { index in
                                            let dataPoint = completeData[index]
                                            VStack(spacing: 5) {
                                                Spacer()
                                                UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10)
                                                    .fill(Color.teamColor(for: team, type: .primary))
                                                    .stroke(Color.teamColor(for: team, type: .secondary), lineWidth: 1)
                                                    .frame(width: 25, height: barHeight(for: dataPoint))
                                                    .overlay(
                                                        UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10)
                                                            .stroke(index == currentTimeIndex ? Color.teamColor(for: team, type: .secondary) : Color.clear, lineWidth: 3) // Highlight border
                                                    )
                                                    .onTapGesture {
                                                        selectedHourST = "\(convertToHoursAndMinutes(from: dataPoint))"
                                                        currentTimeIndex = index
                                                    }
                                                Text("\(formatHour(index)):00 \(formatAMPM(index))")
                                                    .foregroundColor(.black)
                                                    .font(.custom("Montserrat-Bold", size: 12))
                                                    .padding(.top, 1)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height / 8)
                        }.padding(.bottom, 10)
                    }
                }
                .padding(.trailing, 10)
            }.padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            .background(RoundedRectangle(cornerRadius: 15)
                    .fill(Color.teamColor(for: team, type: .fourth))
                  )
                .customRotatingBorder(cornerRadius: 15, gradientColors: [Color.teamColor(for: team, type: .primary).opacity(0.8), Color.teamColor(for: team, type: .fourth).opacity(0.8), Color.teamColor(for: team, type: .primary).opacity(0.8)]).padding(10)
        }
    }
    func prepareData(reportData: [TimeInterval]) -> [TimeInterval] {
        var completeData = Array(repeating: TimeInterval(0), count: 24)
        for (index, dataPoint) in reportData.enumerated() {
            if index < 24 {
                completeData[index] = dataPoint
            }
        }
        return completeData
    }
    private func getCurrentHourIndex() -> Int {
           let calendar = Calendar.current
           let hour = calendar.component(.hour, from: Date())
           return (hour + 12) % 24 // Convert hour to index: 0 for 12 AM, 1 for 1 AM, ..., 12 for 12 PM, etc.
    }
    private func scrollToCurrentTimeIndex(scrollView: ScrollViewProxy, index: Int) {
        withAnimation {
            scrollView.scrollTo(index, anchor: .center)
        }
    }
    private func setupInitialSelection() {
        selectedHourST = "\(convertToHoursAndMinutes(from: reportData.last ?? reportData[0]))"
        currentTimeIndex = Calendar.current.component(.hour, from: Date())
    }


    private func barWidth(totalWidth: CGFloat, count: Int) -> CGFloat {
        let spacing: CGFloat = 5 // Adjusted spacing
        return (totalWidth - (spacing * CGFloat(count - 1))) / CGFloat(count)
    }

    private func barHeight(for value: TimeInterval) -> CGFloat {
        let maxValue = 60.0
        let normalizedValue = CGFloat(value / maxValue)
        return normalizedValue * UIScreen.main.bounds.height / 8 // Adjusted height
    }

    func convertToHoursAndMinutes(from value: Double) -> String {
        let hours = Int(value)
        let decimalPart = value - Double(hours)
        let minutes = Int(decimalPart * 60)
        return "\(hours) min \(minutes) sec"
    }

    private func formatHour(_ hourIndex: Int) -> Int {
        return (hourIndex % 12 == 0) ? 12 : hourIndex % 12
    }

    private func formatAMPM(_ hourIndex: Int) -> String {
        return hourIndex < 12 ? "AM" : "PM"
    }

    @ViewBuilder
    private func YAxisView(maxValue: TimeInterval) -> some View {
        VStack(spacing: 0) {
            Text("\(Int(maxValue)) min")
                .font(.custom("Montserrat-Bold", size: 12))
                .padding(.bottom, 1) // Reduced padding
                .foregroundColor(.black)
            Spacer()
            Text("\(Int(maxValue * 0.5)) min")
                .font(.custom("Montserrat-Bold", size: 12))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(.bottom, 2) // Adjusted padding
    }

    @ViewBuilder
    private func TimeOfDayBackground() -> some View {
        
        GeometryReader { geometry in
            let width = geometry.size.width
            let team = userDefaults?.string(forKey: "team") ?? "water"

            HStack(spacing: 0) {
                Color.teamColor(for: team, type: .accent).opacity(0.2)
                    .frame(width: width / 4)
                Color.teamColor(for: team, type: .accent).opacity(0.4)
                    .frame(width: width / 4)
                Color.teamColor(for: team, type: .accent).opacity(0.6)
                    .frame(width: width / 4)
                Color.teamColor(for: team, type: .accent).opacity(0.8)
                    .frame(width: width / 4)
            }
        }
    }

    private func fontSizePercent(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<700:
            return 23
        case 700..<1000:
            return 25
        case 1000...:
            return 32
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
    
    private func fontSize(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<100:
            return 18
        case 100..<250:
            return 20
        case 250..<405:
            return 25
        case 405...:
            return 35
        default:
            return 35
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
struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.height) / 2.5
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        return path
    }
}


