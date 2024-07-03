//
//  MainRulesView.swift
//  Nix
//
//  Created by Grace Yang on 6/15/24.
//

import SwiftUI
import UIKit
import FirebaseFirestore
import DeviceActivity

struct MainRulesView: View {
    
    @State private var selectedTab = 0
    var userId : String
    @StateObject var viewModel: RulesViewViewModel

    var body: some View {
        VStack (alignment: .trailing) {
            HStack {
                Button(action: {
                    viewModel.showingNewItemView = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.lav).stroke(Color.mauve, lineWidth: 2))
                }
                .padding(.bottom, 5)
                .sheet(isPresented: $viewModel.showingNewItemView) {
                    NewRuleItemView(newItemPresented: $viewModel.showingNewItemView, newTemplate: viewModel.showingTemplateView, userId: userId)
                }
            
            }.padding(.top, 40)

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
            .padding(.bottom, 20)

            if selectedTab == 0 {
                RulesTabView(userId: userId)
            } else {
                ScheduleTabView()
            }
        }
        .padding()
        .padding(.bottom, 60)
        
    }
}

struct RulesTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: RulesViewViewModel
    @State private var selectedItem: RuleItem?
    @State private var selectedTemplate: RuleItem?
    @State private var selectedDays: String = ""
    @State private var userId: String
    @State private var selectedSection = 0  // Track selected section
    @FirestoreQuery var items: [RuleItem]
    @State private var scrollViewOffset: CGFloat = 0  // Track the scroll offset

    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let categoryIcons = ["volleyball.fill", "football.fill", "cricket.ball.fill","tennisball.fill" ]
    let jsonData = loadJsonFromBundle(fileName: "templates")

    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/rules")
        self._viewModel = StateObject(
            wrappedValue: RulesViewViewModel(userId: userId))
        self.userId = userId
        self.selectedDays = ""
    }

    var body: some View {
        VStack(alignment: .trailing) {
           

            VStack(alignment: .leading) { // Add spacing between list items
                List(items.sorted(by: { $0.startTime < $1.startTime })) { item in
                    if item.title != "Pomodoro" {
                        HStack {
                            UnevenRoundedRectangle(cornerRadii: .init(
                                topLeading: 15.0,
                                bottomLeading: 15.0,
                                bottomTrailing: 0,
                                topTrailing: 0),
                                                   style: .continuous)
                            .fill(Color.bubble)
                            .frame(width: 13)
                            
                            Button(action: {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                self.selectedItem = item
                                viewModel.showingEditItemView = true
                            }) {
                                let tokensArray = convertToOriginalTokensArray(selectedApps: item.selectedApps) ?? []
                                
                                RuleRow(
                                    title: item.title,
                                    time: "\(Date(timeIntervalSince1970: item.startTime).formatted(.dateTime.hour().minute())) - \(Date(timeIntervalSince1970: item.endTime).formatted(.dateTime.hour().minute()))",
                                    days: {
                                        if item.selectedDays == [0, 6] {
                                            return "Weekends"
                                        } else if item.selectedDays == [0, 1, 2, 3, 4, 5, 6] {
                                            return "Everyday"
                                        } else if item.selectedDays == [1, 2, 3, 4, 5] {
                                            return "Weekdays"
                                        } else {
                                            return item.selectedDays.map { daysOfWeek[$0] + " " }.joined()
                                        }
                                    }(),
                                    color: Color.bubble,
                                    appsBlocked: tokensArray.count
                                )
                            }
                            .buttonStyle(PlainButtonStyle()) // Remove default button styling
                            
                        }
                        .background {
                            UnevenRoundedRectangle(cornerRadii: .init(
                                topLeading: 15.0,
                                bottomLeading: 15.0,
                                bottomTrailing: 0,
                                topTrailing: 0),
                                                   style: .continuous).fill(Color.white)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("Delete") {
                                let center = DeviceActivityCenter()
                                let activityName = DeviceActivityName(rawValue: "\(item.title)")
                                center.stopMonitoring([activityName])
                                print("stop monitoring")
                                viewModel.delete(id: item.id)
                            }
                            .tint(.red)
                        }
                        .listRowInsets(EdgeInsets())
                        .listStyle(GroupedListStyle())
                    }
                }
                .shadow(color: Color.gray.opacity(0.15), radius: 7, x: 5, y: 5)
                .sheet(isPresented: $viewModel.showingEditItemView) {
                    NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, newTemplate: viewModel.showingTemplateView, userId: userId, item: selectedItem)
                }
                .listStyle(PlainListStyle())
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)

            VStack(alignment: .leading) {
                Text("Suggested")
                    .font(.system(size: 25))
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    .fontWeight(.semibold)

                ScrollViewReader { scrollView in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<jsonData.keys.sorted().count, id: \.self) { index in
                                Button(action: {
                                    withAnimation {
                                        self.selectedSection = index
                                        scrollView.scrollTo(index, anchor: .center)
                                    }
                                }) {
                                    HStack{
                                        Image(systemName: "\(categoryIcons[index])")
                                            .foregroundColor(index == selectedSection ? .white : .black)
                                        Text(jsonData.keys.sorted()[index])
                                            .foregroundColor(index == selectedSection ? .white : .black)
                                            .fontWeight(.bold)
                                    }
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 20)
                                            .background(index == selectedSection ? Color.lav : Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 35))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 35)
                                                    .stroke(index == selectedSection ? Color.mauve : Color.clear, lineWidth: index == selectedSection ? 2 : 1)
                                            )
                                            .animation(.easeInOut(duration: 0.1), value: selectedSection)
                                    
                                }
                                .padding(.trailing, 10)
                                .padding(.leading, 5)
                                .id(index)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                

                GeometryReader { geometry in
                    TabView(selection: $selectedSection) {
                        ForEach(jsonData.keys.sorted(), id: \.self) { category in
                            VStack {
                                if jsonData.keys.sorted().firstIndex(of: category) == selectedSection {
                                    List {
                                        ForEach(jsonData[category]!, id: \.id) { template in
                                            HStack {

                                                Button(action: {
                                                    self.selectedItem = template
                                                    viewModel.showingTemplateView = true
                                                    viewModel.showingEditItemView = true
                                                }) {
                                                    let tokensArray = convertToOriginalTokensArray(selectedApps: template.selectedApps) ?? []
                                                    
                                                    SuggestRow(
                                                        title: template.title,
                                                        time: "\(Date(timeIntervalSince1970: template.startTime).formatted(.dateTime.hour().minute())) - \(Date(timeIntervalSince1970: template.endTime).formatted(.dateTime.hour().minute()))",
                                                        appsBlocked: tokensArray.count,
                                                        color: Color.blue
                                                    )
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                                .stroke(1)
                                                .buttonStyle(PlainButtonStyle())
                                                .listRowInsets(EdgeInsets())
                                                .listRowBackground(Color.white)
                                                .sheet(isPresented: $viewModel.showingEditItemView) {
                                                    NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, newTemplate: viewModel.showingTemplateView, userId: userId, item: selectedItem)
                                                }
                                            }
                                        }
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                        )
                                        .listRowInsets(EdgeInsets())
                                        .listStyle(PlainListStyle())
                                    }
                                    .listStyle(PlainListStyle())
                                    .shadow(color: Color.gray.opacity(0.15), radius: 7, x: 5, y: 5)
                                }
                            }
                            .tag(jsonData.keys.sorted().firstIndex(of: category) ?? 0)
                            .onChange(of: selectedSection) { newValue in
                                // Scroll to the selected index in the horizontal scroll view
                                withAnimation {
                                    scrollView.scrollTo(newValue, anchor: .center)
                                }
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.1), value: selectedSection)  // Smooth transition for TabView
                }
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

func loadJsonFromBundle(fileName: String) -> [String: [RuleItem]] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonData = try? JSONDecoder().decode([String: [RuleItem]].self, from: data) else {
            fatalError("Failed to load JSON file.")
        }
        return jsonData
    }

func formatTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }

//#Preview {
////    MainRulesView(userId: "Grace", viewModel: RulesViewViewModel(userId: userId))
//}
