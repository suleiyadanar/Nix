import SwiftUI
import Charts // Assuming Charts is a custom or third-party library

struct ChartReportDayView: View {
    let reportData: [TimeInterval]
    @State private var currentTimeIndex: Int? = nil

    var body: some View {
        let completeData = prepareData(reportData: reportData)
        
        ScrollViewReader { scrollView in
            HStack(spacing: 10) {
                YAxisView(maxValue: 60)
                    .frame(height: UIScreen.main.bounds.height / 4)

                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack {
                        TimeOfDayBackground()
                            .frame(height: UIScreen.main.bounds.height / 4)
                        
                        HStack(spacing: 10) {
                            ForEach(Array(completeData.enumerated()), id: \.offset) { index, dataPoint in
                                VStack {
                                    Spacer(minLength: 0)
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(Color.blue)
                                        .frame(width: barWidth(totalWidth: UIScreen.main.bounds.width, count: completeData.count), height: barHeight(for: dataPoint))
                                    Text("\(formatHour(index)):00 \(formatAMPM(index))")
                                        .font(.custom("Nunito-Medium", size: 15))
                                        .padding(.top, 2)
                                }
                                .id(index)
                            }
                        }
                    }
                    .onAppear {
                                            // Set currentTimeIndex to the current hour
                                            let currentHour = Calendar.current.component(.hour, from: Date())
                                            currentTimeIndex = currentHour

                                            // Automatically scroll to the current time index
                                            if let currentTimeIndex = currentTimeIndex, currentTimeIndex >= 0 {
                                                scrollToCurrentTimeIndex(scrollView: scrollView, index: currentTimeIndex)
                                            }
                                        }                    .onChange(of: currentTimeIndex) { newIndex in
                        // Re-scroll to the updated current time index
                        if let newIndex = newIndex {
                            scrollToCurrentTimeIndex(scrollView: scrollView, index: newIndex)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 4)
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
        let spacing: CGFloat = 10
        return (totalWidth - (spacing * CGFloat(count - 1))) / CGFloat(count)
    }

    private func barHeight(for value: TimeInterval) -> CGFloat {
        let maxValue = 60.0 // Get maximum value from reportData or default to 60
        let normalizedValue = CGFloat(value / maxValue)
        return normalizedValue * UIScreen.main.bounds.height / 4
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
                .font(.custom("Nunito-Medium", size: 15))
                .padding(.bottom, 2)
            Spacer()
            Text("\(Int(maxValue * 0.5)) min")
                .font(.custom("Nunito-Medium", size: 15))
            Spacer()
        }
        .padding(.bottom, 5)
    }

    @ViewBuilder
    private func TimeOfDayBackground() -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            HStack(spacing: 0) {
                Color.babyBlue.opacity(0.2)
                    .frame(width: width / 4) // 6 AM - 12 PM
                Color.babyBlue.opacity(0.4)
                    .frame(width: width / 4) // 12 PM - 6 PM
                Color.babyBlue.opacity(0.6)
                    .frame(width: width / 4) // 6 PM - 10 PM
                Color.babyBlue.opacity(0.8)
                    .frame(width: width / 4) // 10 PM - 6 AM
            }
        }
    }
}
