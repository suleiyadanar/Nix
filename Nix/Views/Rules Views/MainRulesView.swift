//
//  MainRulesView.swift
//  Nix
//
//  Created by Grace Yang on 6/15/24.
//

import SwiftUI

struct MainRulesView: View {
    
    @State private var selectedTab = 0
    var userId : String

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedTab = 0
                }) {
                    Text("Rules")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .background(selectedTab == 0 ? Color.babyBlue : Color.clear)
                        .foregroundStyle(selectedTab == 0 ? Color.white : Color.black)
                        .cornerRadius(5)
                }
                Button(action: {
                    selectedTab = 1
                }) {
                    Text("Schedule")
                        .frame(maxWidth: .infinity,  maxHeight: 35)
                        .background(selectedTab == 1 ? Color.babyBlue : Color.clear)
                        .foregroundStyle(selectedTab == 1 ? Color.white : Color.black)
                        .cornerRadius(5)
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 20)

            if selectedTab == 0 {
                RulesTabView()
            } else {
                ScheduleTabView()
            }
        }
        .padding()
    }
}

struct RulesTabView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    // Action for the + button
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
                .padding(.bottom, 5)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    RuleRow(title: "Morning Me-Time", time: "8:00pm - 9:00am", days: "Weekdays", color: Color.bubble, appsBlocked: 10)
                    RuleRow(title: "Physics 273 Lecture", time: "1:30pm - 3:00pm", days: "M W", color: Color.lemon, appsBlocked: 8)
                    RuleRow(title: "Chemistry 101 Lecture", time: "3:10pm - 4:00pm", days: "T Th", color: Color.apricot, appsBlocked: 12)
                    RuleRow(title: "Study Session", time: "12:12pm - 4:00pm", days: "Weekends", color: Color.mango, appsBlocked: 12)
                    RuleRow(title: "Bedtime Yoga", time: "10:00pm - 11:00pm", days: "Everyday", color: Color.poppy, appsBlocked: 10)
                    
                    Text("Suggested")
                        .font(.system(size: 18))
                        .padding(.leading, 5)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    SuggestRow(title: "Club Meeting", time: "7:00pm - 8:00pm", appsBlocked: 3, color: Color.sky)
                    SuggestRow(title: "Volunteer at Shelter", time: "5:00pm - 6:00pm", appsBlocked: 5, color: Color.mauve)
                    SuggestRow(title: "Part-time Job", time: "6:00pm - 7:00pm", appsBlocked: 5, color: Color.apricot)
                }
            }
        }
    }
}

struct ScheduleTabView: View {
    let scheduleItems: [ScheduleItem] = [
        ScheduleItem(startTime: "10:00am", endTime: "11:00am", title: "Morning study session", details: "10 apps blocked", color: .bubble, appsBlocked: 10, hasAlarm: false, isSuggested: false),
        ScheduleItem(startTime: "11:00am", endTime: "01:00pm", title: "Study for Calculus Test", details: "23 apps blocked", color: .lav, appsBlocked: 23, hasAlarm: true, isSuggested: false),
        ScheduleItem(startTime: "03:00pm", endTime: "04:00pm", title: "Academic Advisor Meeting", details: "Add", color: .bubble, appsBlocked: 0, hasAlarm: false, isSuggested: true)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Today's Schedule")
                    .font(.system(size: 20))
                Spacer()
                HStack(spacing: 10) {
                    Button(action: {
                        // Action for the previous day
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    Text("June 5")  // Replace this with dynamic date if needed
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Button(action: {
                        // Action for the next day
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.bottom, 5)
            
            ScrollView {
                ZStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 50) {
                        ForEach(10..<19) { hour in
                            HStack {
                                TimeStampView(hour: hour)
                                Image("scheduleline")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 265)
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 12)
                    
                    ZStack(alignment: .top) {
                        ForEach(scheduleItems) { item in
                            ScheduleRow(item: item)
                                .padding(.horizontal)
                                .offset(y: CGFloat((timeStringToInt(item.startTime) - 10)) * 68) // aligns it with correct start time
                                .padding(11)
                                .padding(.leading, 12)
                        }
                        
                        // blue line indicator
                        let currentTimeY = CGFloat((timeStringToInt(currentTimeString()) - 10)) * 68 + currentMinuteOffset()
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.sky)
                                .frame(width: 260, height: 1.5)
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                                .offset(x: -4) // Move the circle to the left to center it on the line
                        }
                        .offset(y: currentTimeY)
                        .padding(.leading, 35)

                    }
                    .padding(.leading, 40)
                }
            }
        }
    }
    
    private func timeStringToInt(_ time: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        guard let date = dateFormatter.date(from: time) else { return 0 }
        let calendar = Calendar.current
        return calendar.component(.hour, from: date)
    }
    
    private func currentTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        return dateFormatter.string(from: Date())
    }
    
    private func currentMinuteOffset() -> CGFloat {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: Date())
        return CGFloat(minutes) / 60 * 68 // assuming each hour is represented by 68 points
    }
}

struct TimeStampView: View {
    let hour: Int

    var body: some View {
        Text(String(format: "%02d", hour % 12 == 0 ? 12 : hour % 12) + " \(hour < 12 ? "AM" : "PM")")
            .font(.subheadline)
            .foregroundColor(.black)
            .frame(width: 60, alignment: .leading)
    }
}

#Preview {
    MainRulesView(userId: "Grace")
}
