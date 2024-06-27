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
                
                ScheduleRow(title: "Morning Me-Time", time: "8:00pm - 9:00am", days: "Weekdays", color: Color.bubble, appsBlocked: 10, isSuggested: false)
                ScheduleRow(title: "Physics 273 Lecture", time: "1:30pm - 3:00pm", days: "M W", color: Color.lemon, appsBlocked: 8, isSuggested: false)
                ScheduleRow(title: "Chemistry 101 Lecture", time: "3:10pm - 4:00pm", days: "T Th", color: Color.apricot, appsBlocked: 12, isSuggested: false)
                ScheduleRow(title: "Study Session", time: "12:12pm - 4:00pm", days: "Weekends", color: Color.mango, appsBlocked: 12, isSuggested: false)
                ScheduleRow(title: "Bedtime Yoga", time: "10:00pm - 11:00pm", days: "Everyday", color: Color.poppy, appsBlocked: 10, isSuggested: false)
                
                Text("Suggested")
                    .font(.title)
                    .padding(.leading)
                
                ScheduleRow(title: "Club Meeting", time: "7:00pm - 8:00pm", days: "", color: Color.sky, appsBlocked: 3, isSuggested: true)
                ScheduleRow(title: "Volunteer at Shelter", time: "5:00pm - 6:00pm", days: "", color: Color.mauve, appsBlocked: 5, isSuggested: true)
                ScheduleRow(title: "Part-time Job", time: "6:00pm - 7:00pm", days: "", color: Color.apricot, appsBlocked: 5, isSuggested: true)
            }
        }
    }
}

struct ScheduleTabView: View {
    var body: some View {
        Text("This is the content of Tab 2")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ScheduleRow: View {
    var title: String
    var time: String
    var days: String
    var color: Color
    var appsBlocked: Int
    var isSuggested: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Color tag on the left
            Rectangle()
                .fill(color) // Change this to the desired color
                .frame(width: 10) // Adjust width as needed
            
            VStack(alignment: .leading) {
                if isSuggested {
                    // Suggested item layout
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                            .padding(.bottom, 2)
                        Text(time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Text("\(appsBlocked) apps blocked")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Button(action: {
                                // Add action
                            }) {
                                Text("Add")
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.yellow)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                } else {
                    // Regular schedule layout
                    VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .font(.headline)
                                .padding(.bottom, 2)
                            Spacer()
                            Text(days)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        HStack {
                            Text(time)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(appsBlocked) apps blocked")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    
                }
            }
        }
        .cornerRadius(15)
        .shadow(radius: 0.5)
        .padding(.horizontal)
    }
}


#Preview {
    MainRulesView(userId: "Grace")
}
