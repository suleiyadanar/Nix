import SwiftUI

struct ChartReportWeekView: View {
  
    let weeklyReportData: [TimeInterval] // Array for each day's data
    @State private var currentDayIndex: Int? = nil
    @State private var selectedDayST: String = ""

    var body: some View {
        let completeData = prepareData(reportData: weeklyReportData)
        ScrollViewReader { scrollView in
            VStack(spacing: 10) {
                Text(selectedDayST) // Show selected day's data as title text
                    .font(.title) // Adjust font size as needed
                HStack(spacing: 10) {
                    YAxisView(maxValue: weeklyReportData.max() ?? 24)
                        .frame(width: 50) // Adjust width as needed

                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                            TimeOfDayBackground()
                            
                            HStack(spacing: 10) {
                                ForEach(Array(completeData.enumerated()), id: \.offset) { index, dayData in
                                    VStack {
                                        Spacer() // Ensure minimal vertical spacing
                                        RoundedRectangle(cornerRadius: 0)
                                            .fill(Color.blue)
                                            .frame(width: barWidth(totalWidth: UIScreen.main.bounds.width, count: completeData.count), height: barHeight(for: dayData))
                                            .onTapGesture {
                                                selectedDayST = "\(dayOfWeek(index)): \(convertToHoursAndMinutes(from: dayData))" // Update selected day text
                                                currentDayIndex = index // Update selected day index
                                            }
                                        Text(dayOfWeek(index))
                                            .font(.custom("Nunito-Medium", size: 15))
                                            .padding(.top, 2) // Adjust vertical positioning
                                    }
                                    .id(index) // Ensure each view has a unique identifier for ScrollViewReader
                                }
                            }
                            .padding(.leading, 50) // Adjust as needed for Y-axis labels
                        }
                        .onAppear {
                            // Set the currentDayIndex
                            currentDayIndex = weeklyReportData.count + 1

                            // Automatically scroll to the current day index
                            if let currentDayIndex = currentDayIndex {
                                scrollToCurrentDayIndex(scrollView: scrollView, index: currentDayIndex)
                            }
                        }
                        .onChange(of: currentDayIndex) { newIndex in
                            // Re-scroll to the updated current day index
                            if let newIndex = newIndex {
                                scrollToCurrentDayIndex(scrollView: scrollView, index: newIndex)
                            }
                        }
                        .padding(.bottom, 20) // Adjust bottom padding to ensure x-axis labels are fully visible
                    }
                    .frame(height: UIScreen.main.bounds.height / 4) // Adjust height as needed
                }
                .frame(height: UIScreen.main.bounds.height / 4) // Adjust height as needed
            }
        }
    }

    func prepareData(reportData: [TimeInterval]) -> [TimeInterval] {
        return reportData
    }

    private func scrollToCurrentDayIndex(scrollView: ScrollViewProxy, index: Int) {
        withAnimation {
            scrollView.scrollTo(index, anchor: .center)
        }
    }

    private func barWidth(totalWidth: CGFloat, count: Int) -> CGFloat {
        let spacing: CGFloat = 10
        return (totalWidth - (spacing * CGFloat(count - 1))) / CGFloat(count)
    }

    private func barHeight(for value: TimeInterval) -> CGFloat {
        let maxValue = weeklyReportData.max() ?? 24.0 // Adjust based on maximum screen time or default to 24
        let normalizedValue = CGFloat(value / maxValue)
        return normalizedValue * UIScreen.main.bounds.height / 4 // Adjust height scaling
    }

    private func dayOfWeek(_ dayIndex: Int) -> String {
        let todayIndex = Calendar.current.component(.weekday, from: Date())
        let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let adjustedIndex = (todayIndex + dayIndex) % 7
        return weekdays[adjustedIndex]
    }

    func convertToHoursAndMinutes(from value: Double) -> String {
        let hours = Int(value) // Get the integer part as hours
        let decimalPart = value - Double(hours) // Get the decimal part
        
        // Convert decimal part to minutes
        let minutes = Int(decimalPart * 60)
        
        return "\(hours) hrs \(minutes) mins"
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        // Get the formatted string from the interval
        guard let formattedString = formatter.string(from: interval) else {
            return ""
        }
        
        // Split the formatted string into components
        let components = formattedString.split(separator: ",")
        
        if components.count == 2 {
            let hoursString = components[0].trimmingCharacters(in: .whitespaces)
            let minutesString = components[1].trimmingCharacters(in: .whitespaces)
            
            return "\(hoursString) hrs \(minutesString) mins"
        } else {
            return formattedString
        }
    }
    
    @ViewBuilder
    private func YAxisView(maxValue: TimeInterval) -> some View {
        VStack(spacing: 0) {
            Text("\(Int(maxValue)) hrs")
                .font(.custom("Nunito-Medium", size: 15))
                .padding(.bottom, 2) // Adjust for vertical alignment
            Spacer()
            Text("\(Int(maxValue * 0.5)) hrs")
                .font(.custom("Nunito-Medium", size: 15))
            Spacer()
        }
        .padding(.trailing, 5) // Adjust for Y-axis labels alignment
    }

    @ViewBuilder
    private func TimeOfDayBackground() -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            HStack(spacing: 0) {
                Color.blue.opacity(0.2)
                    .frame(width: width / 7) // Adjust for 7 days
                Color.blue.opacity(0.4)
                    .frame(width: width / 7)
                Color.blue.opacity(0.6)
                    .frame(width: width / 7)
                Color.blue.opacity(0.8)
                    .frame(width: width / 7)
                Color.blue.opacity(0.6)
                    .frame(width: width / 7)
                Color.blue.opacity(0.4)
                    .frame(width: width / 7)
                Color.blue.opacity(0.2)
                    .frame(width: width / 7)
            }
        }
    }
}
