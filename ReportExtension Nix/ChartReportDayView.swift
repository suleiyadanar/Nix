import SwiftUI
import Charts // Assuming Charts is a custom or third-party library

struct ChartReportDayView: View {
    let reportData: [TimeInterval]
    @State private var currentTimeIndex: Int? = nil
    @State private var selectedHourST: String = ""
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    var body: some View {
        VStack(alignment: .leading) {
            Text(selectedHourST) // Show selected day's data as title text
                .font(.custom("Montserrat-Bold", size: 12))
            
            let completeData = prepareData(reportData: reportData)
            let team = userDefaults?.string(forKey: "team") ?? "water"
            
            ScrollViewReader { scrollView in
                HStack(spacing: 10) {
                    YAxisView(maxValue: 60)
                        .frame(height: barHeight(for: 60))
                        .padding(.bottom, 10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack {
                            TimeOfDayBackground()
                                .frame(height: barHeight(for: 60))
                                .padding(.bottom, 10) // Reduced padding

                            HStack(spacing: 5) { // Reduced spacing for smaller bars
                                ForEach(Array(completeData.enumerated()), id: \.offset) { index, dataPoint in
                                    VStack(spacing:5) {
                                        Spacer()
                                        RoundedRectangle(cornerRadius: 10) // Reduced corner radius
                                            .fill(Color.teamColor(for: team, type: .primary))
                                            .stroke(Color.teamColor(for: team, type: .secondary), lineWidth: 1) // Reduced stroke width
                                            .frame(width: 25, height: barHeight(for: dataPoint)) // Reduced width
                                            .onTapGesture {
                                                selectedHourST = "\(convertToHoursAndMinutes(from: dataPoint))"
                                                currentTimeIndex = index // Update selected day index
                                            }
                                        Text("\(formatHour(index)):00 \(formatAMPM(index))")
                                            .font(.custom("Montserrat-Bold", size: 12))
//                                            .font(.custom("Nunito-Medium", size: 12)) // Reduced font size
                                            .padding(.top, 1) // Reduced padding
                                    }
                                    .id(index)
                                }
                            }
                        }
                        .onAppear {
                            selectedHourST = "\(convertToHoursAndMinutes(from: reportData.last ?? reportData[0]))"
                            let currentHour = Calendar.current.component(.hour, from: Date())
                            currentTimeIndex = currentHour
                            
                            if let currentTimeIndex = currentTimeIndex, currentTimeIndex >= 0 {
                                scrollToCurrentTimeIndex(scrollView: scrollView, index: currentTimeIndex)
                            }
                        }
                        .onChange(of: currentTimeIndex) { newIndex in
                            if let newIndex = newIndex {
                                scrollToCurrentTimeIndex(scrollView: scrollView, index: newIndex)
                            }
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 8)
                }
            }
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

    private func scrollToCurrentTimeIndex(scrollView: ScrollViewProxy, index: Int) {
        withAnimation {
            scrollView.scrollTo(index, anchor: .center)
        }
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
            Spacer()
            Text("\(Int(maxValue * 0.5)) min")
                .font(.custom("Montserrat-Bold", size: 12))
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
}

