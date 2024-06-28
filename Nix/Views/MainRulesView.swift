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
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                RuleRow(title: "Morning Me-Time", time: "8:00pm - 9:00am", days: "Weekdays", color: Color.bubble, appsBlocked: 10, isSuggested: false)
                RuleRow(title: "Physics 273 Lecture", time: "1:30pm - 3:00pm", days: "M W", color: Color.lemon, appsBlocked: 8, isSuggested: false)
                RuleRow(title: "Chemistry 101 Lecture", time: "3:10pm - 4:00pm", days: "T Th", color: Color.apricot, appsBlocked: 12, isSuggested: false)
                RuleRow(title: "Study Session", time: "12:12pm - 4:00pm", days: "Weekends", color: Color.mango, appsBlocked: 12, isSuggested: false)
                RuleRow(title: "Bedtime Yoga", time: "10:00pm - 11:00pm", days: "Everyday", color: Color.poppy, appsBlocked: 10, isSuggested: false)
                
                Text("Suggested")
                    .font(.title)
                    .padding(.leading)
                
                RuleRow(title: "Club Meeting", time: "7:00pm - 8:00pm", days: "", color: Color.sky, appsBlocked: 3, isSuggested: true)
                RuleRow(title: "Volunteer at Shelter", time: "5:00pm - 6:00pm", days: "", color: Color.mauve, appsBlocked: 5, isSuggested: true)
                RuleRow(title: "Part-time Job", time: "6:00pm - 7:00pm", days: "", color: Color.apricot, appsBlocked: 5, isSuggested: true)
            }
        }
    }
}

struct RuleRow: View {
    var title: String
    var time: String
    var days: String
    var color: Color
    var appsBlocked: Int
    var isSuggested: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Color tag on the left
            UnevenRoundedRectangle(cornerRadii: .init(
                                   topLeading: 15.0,
                                   bottomLeading: 15.0,
                                   bottomTrailing: 0,
                                   topTrailing: 0),
                                   style: .continuous)
                .fill(color)
                .background(Color.clear)
                .frame(width: 10)
                .offset(x: 5)
                .zIndex(1)

            VStack(alignment: .leading) {
                if isSuggested {
                    // Suggested item layout
                    VStack(alignment: .leading) {
                        Spacer(minLength: 10)

                        HStack {
                            Text(title)
                                .padding(.bottom, 2)
                            Spacer()
                            
                            Button(action: {
                                // Add action
                            }) {
                                HStack {
                                    Text("Add")
                                        .font(.caption)
                                        .foregroundStyle(Color.mauve)
                                        .offset(x: 1)
                                    Image(systemName: "plus.circle")
                                        .font(.headline)
                                        .foregroundColor(.mauve)
                                        .offset(x: -1)
                                }
                                .padding(.leading, 5)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Color.lemon)
                                .cornerRadius(20)
                            }
                        }
                        Spacer(minLength: 15)
                        HStack {
                            Image(systemName: "clock")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            Text(time)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(appsBlocked) apps blocked")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 5)

                    }
                    .padding(7)
                    .background(Color.white)
                    .cornerRadius(10)
                } else {
                    // Regular schedule layout
                    VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .padding(.bottom, 2)
                            Spacer()
                            if !days.isEmpty {
                                HStack(spacing: 5) {
                                    ForEach(days.split(separator: " "), id: \.self) { day in
                                        Text(String(day))
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 5)
                                            .padding(.vertical, 2)
                                            .background(Color.babyBlue)
                                            .cornerRadius(15)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 5)

                        Spacer(minLength: 15)
                        HStack {
                            Image(systemName: "clock")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            Text(time)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(appsBlocked) apps blocked")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 5)

                    }
                    .padding(7)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
        .background {
            UnevenRoundedRectangle(cornerRadii: .init(
                topLeading: 0,
                bottomLeading: 0,
                bottomTrailing: 15.0,
                topTrailing: 15.0),
                                   style: .continuous)
            .cornerRadius(15)
            .padding(.horizontal, 15)
            .padding(.bottom, 5)

        }
        .shadow(radius: 0.5)

    }
}

struct ScheduleItem: Identifiable {
    let id = UUID()
    let time: String
    let title: String
    let details: String
    let color: Color
    let appsBlocked: Int
}

struct ScheduleRow: View {
    var item: ScheduleItem
    
    var body: some View {
        HStack(spacing: 0) {
            // Color tag on the left
            RoundedRectangle(cornerRadius: 10)
                .fill(item.color)
                .frame(width: 10)
                .offset(x: 5)
                .zIndex(1)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.title)
                            .padding(.bottom, 2)
                        Spacer()
                    }
                    .padding(.leading, 5)
                    
                    Spacer(minLength: 15)
                    HStack {
                        Image(systemName: "clock")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(item.time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(item.appsBlocked) apps blocked")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 5)
                    
                }
                .padding(7)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.clear)
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
        }
    }
}

struct TimeStampView: View {
    let hour: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(hour % 12 == 0 ? 12 : hour % 12) \(hour < 12 ? "AM" : "PM")")
                .font(.subheadline)
                .foregroundColor(.black)
                .frame(height: 40)
        }
    }
}

struct ScheduleTabView: View {
    let scheduleItems: [ScheduleItem] = [
        ScheduleItem(time: "10:00am - 11:00am", title: "Morning study session", details: "10 apps blocked", color: .bubble, appsBlocked: 10),
        ScheduleItem(time: "11:00am - 01:00pm", title: "Study for Calculus Test", details: "23 apps blocked", color: .lav, appsBlocked: 23),
        ScheduleItem(time: "03:00pm - 04:00pm", title: "Academic Advisor Meeting", details: "Add", color: .bubble, appsBlocked: 0)
    ]
    
    var body: some View {
        HStack {
           Text("Today's Schedule")
                .font(.system(size: 25))
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
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 40) {
                    ForEach(10..<24) { hour in
                        TimeStampView(hour: hour)
                    }
                }
                .padding(.leading, 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(scheduleItems) { item in
                        ZStack {
                            Image("scheduleline") // Replace with the name of your PNG in Assets
                                .resizable()
                                .frame(height: 1)
                                .padding(.trailing)
                            ScheduleRow(item: item)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Spacer to push the last item down to make the list scrollable till 12 AM
                    Spacer().frame(height: 600)
                }
            }
        }
    }
}

#Preview {
    MainRulesView(userId: "Grace")
}
