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
    var props: Properties

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
                    RuleSettingsView()
                    //NewRuleItemView(newItemPresented: $viewModel.showingNewItemView,  userId: userId)
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
        ZStack(alignment: .bottomTrailing) {
            VStack {
                List(items.sorted(by: { $0.startTime < $1.startTime })) { item in
                    if item.title != "Pomodoro" {
                        HStack {
                            UnevenRoundedRectangle(cornerRadii: .init(
                                topLeading: 15.0,
                                bottomLeading: 15.0,
                                bottomTrailing: 0,
                                topTrailing: 0),
                                style: .continuous)
                            .fill(Color(item.color))
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
                .shadow(color: Color.gray.opacity(0.15), radius: 6, x: 0, y: 5)
                .sheet(isPresented: $viewModel.showingEditItemView) {
                    NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, userId: userId, item: selectedItem, color:selectedItem?.color ?? "swatch_lemon")
                }
                .listStyle(PlainListStyle())
            }

            Button(action: {
                viewModel.showingExploreRules = true
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
                .padding()
                .background(UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 25.0,
                    bottomLeading: 25.0,
                    bottomTrailing: 0,
                    topTrailing: 25.0),
                    style: .continuous)
                    .fill(Color.lemon)
                )
                .foregroundColor(.white)
//                .cornerRadius(25)
                .shadow(color: Color.gray.opacity(0.15), radius: 5, x: 5, y: 5)
            }
            .padding(.bottom, 5)
            .sheet(isPresented: $viewModel.showingExploreRules) {
                VStack {
                    Divider()
                    ScrollViewReader { scrollView in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(0..<jsonData.keys.sorted().count, id: \.self) { index in
                                    Button(action: {
                                        withAnimation {
                                            self.selectedSection = index
                                            scrollView.scrollTo(index, anchor: .center)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "\(categoryIcons[index])")
                                                .foregroundColor(index == selectedSection ? .white : .black)
                                            Text(jsonData.keys.sorted()[index])
                                                .foregroundColor(index == selectedSection ? .white : .black)
                                                .fontWeight(.bold)
                                                .font(.subheadline)
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
                                    .padding(.horizontal, 3)
                                    .id(index)
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 2)
                        }
                        .padding(.horizontal, 15)
                        .onAppear {
                            withAnimation {
                                self.selectedSection = 0
                                scrollView.scrollTo(0, anchor: .center)
                            }
                        }
                        GeometryReader { geometry in
                            TabView(selection: $selectedSection) {
                                ForEach(jsonData.keys.sorted(), id: \.self) { category in
                                    VStack(alignment: .leading, spacing: 0) {
                                        if jsonData.keys.sorted().firstIndex(of: category) == selectedSection {
                                            List {
                                                LazyVGrid(columns: [GridItem(.flexible(), spacing: geometry.size.width < 600 ? 7 : 15), GridItem(.flexible(), spacing: geometry.size.width < 600 ? 7 : 15)], spacing: geometry.size.width < 600 ? 7 : 15) {
                                                    ForEach(jsonData[category]!, id: \.id) { template in
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
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                        .listRowInsets(EdgeInsets())
                                                        .listRowBackground(Color.white)
                                                        .sheet(isPresented: $viewModel.showingEditItemView) {
                                                            NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, userId: userId, item: selectedItem, color:selectedItem?.color ?? "swatch_lemon")
                                                        }
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color.white)
                                                                .stroke(Color.lightGray, lineWidth: 1.5)
                                                                .shadow(color: Color.gray.opacity(0.15), radius: 5, x: 0, y: 5)
                                                        )
                                                        .listRowSeparator(.hidden)
                                                        .listRowInsets(EdgeInsets())
                                                    }
                                                }
                                            }
                                            .listStyle(PlainListStyle())
                                        }
                                    }
                                    .tag(jsonData.keys.sorted().firstIndex(of: category) ?? 0)
                                    .onChange(of: selectedSection) {
                                        // Scroll to the selected index in the horizontal scroll view
                                        withAnimation {
                                            scrollView.scrollTo(selectedSection, anchor: .center)
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
}
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
//            
//            Spacer(minLength: 15)
//            VStack(alignment: .leading) {
//               
//                Divider()
//                ScrollViewReader { scrollView in
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 10) {
//                            ForEach(0..<jsonData.keys.sorted().count, id: \.self) { index in
//                                Button(action: {
//                                    withAnimation {
//                                        self.selectedSection = index
//                                        scrollView.scrollTo(index, anchor: .center)
//                                    }
//                                }) {
//                                    HStack{
//                                        Image(systemName: "\(categoryIcons[index])")
//                                            .foregroundColor(index == selectedSection ? .white : .black)
//                                        Text(jsonData.keys.sorted()[index])
//                                            .foregroundColor(index == selectedSection ? .white : .black)
//                                            .fontWeight(.bold)
//                                            .font(.subheadline)
//                                        
//                                    }
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 20)
//                                    .background(index == selectedSection ? Color.lav : Color.white)
//                                    .clipShape(RoundedRectangle(cornerRadius: 35))
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 35)
//                                            .stroke(index == selectedSection ? Color.mauve : Color.clear, lineWidth: index == selectedSection ? 2 : 1)
//                                    )
//                                    .animation(.easeInOut(duration: 0.1), value: selectedSection)
//                                    
//                                }
//                                .padding(.horizontal, 3)
//                                .id(index)
//                            }
//                        }
//                        .padding(.top, 10)
//                        .padding(.bottom, 2)
//                    }.padding(.horizontal, 15)
//                    GeometryReader { geometry in
//                        TabView(selection: $selectedSection) {
//                            ForEach(jsonData.keys.sorted(), id: \.self) { category in
//                                VStack(alignment: .leading, spacing:0) {
//                                    if jsonData.keys.sorted().firstIndex(of: category) == selectedSection {
//                                        List {
//                                            LazyVGrid(columns: geometry.size.width < 600 ? [GridItem(.flexible())] : [GridItem(.flexible(), spacing: geometry.size.width < 600 ? 7 : 15), GridItem(.flexible(), spacing: geometry.size.width < 600 ? 7 : 15)], spacing: geometry.size.width < 600 ? 7 : 15) {
//                                                ForEach(jsonData[category]!, id: \.id) { template in
//                                                    Button(action: {
//                                                        self.selectedItem = template
//                                                        viewModel.showingTemplateView = true
//                                                        viewModel.showingEditItemView = true
//                                                    }) {
//                                                        let tokensArray = convertToOriginalTokensArray(selectedApps: template.selectedApps) ?? []
//                                                        
//                                                        SuggestRow(
//                                                            title: template.title,
//                                                            time: "\(Date(timeIntervalSince1970: template.startTime).formatted(.dateTime.hour().minute())) - \(Date(timeIntervalSince1970: template.endTime).formatted(.dateTime.hour().minute()))",
//                                                            appsBlocked: tokensArray.count,
//                                                            color: Color.blue
//                                                        )
//                                                    }
//                                                    .buttonStyle(PlainButtonStyle())
//                                                    .listRowInsets(EdgeInsets())
//                                                    .listRowBackground(Color.white)
//                                                    .sheet(isPresented: $viewModel.showingEditItemView) {
//                                                        NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, userId: userId, item: selectedItem, color:selectedItem?.color ?? "swatch_lemon")
//                                                    }
//                                                    .background(
//                                                        RoundedRectangle(cornerRadius: 10)
//                                                            .fill(Color.white)
//                                                            .stroke(Color.lightGray, lineWidth: 1.5)
//                                                            .shadow(color: Color.gray.opacity(0.15), radius: 5, x: 0, y: 5)
//                                                    )
//                                                    .listRowSeparator(.hidden)
//                                                    .listRowInsets(EdgeInsets())
//                                                }
//                                            }
//                                        }
//                                        .listStyle(PlainListStyle())
//                                    }
//                                }
//                                .tag(jsonData.keys.sorted().firstIndex(of: category) ?? 0)
//                                .onChange(of: selectedSection) {
//                                    // Scroll to the selected index in the horizontal scroll view
//                                    withAnimation {
//                                        scrollView.scrollTo(selectedSection, anchor: .center)
//                                    }
//                                }
//                            }
//                        }
//                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                        .animation(.easeInOut(duration: 0.1), value: selectedSection)  // Smooth transition for TabView
//                        
//                    }
//                }
//            
//            }.frame(maxHeight:220)
//        }
//    }
//}

struct ScheduleTabView: View {
    @State private var currentWeekOffset = 0
    @State private var initialScrollDone = false
    @State private var selectedDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var scheduleItems: [ScheduleItem] = []
    @State private var clasificationIdentifier: [CalendarEvent] = []

    var body: some View {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Today's Schedule")
                                .font(.system(size: 20))
                            Spacer()
                            if clasificationIdentifier.isEmpty {
                                ViewControllerRepresentableView(
                                    identifier: $clasificationIdentifier,
                                    startDateTime: selectedDate,
                                    endDateTime: endDate
                                ).background(Color.green)
                                    .frame(width: 220, height:50)
                            }
                        }.frame(height:50)
                        WeeklySnapScrollView(selectedDate: $selectedDate, currentWeekOffset: $currentWeekOffset)
                            .padding(0)
                    }
                    .padding(0)
                }
                .padding(0)

                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        ZStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 50) {
                                ForEach(0..<24) { hour in
                                    HStack {
                                        TimeStampView(hour: hour)
                                        Image("scheduleline")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: 265)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .id(hour) // Add an ID to each hour for scrolling
                                }
                            }
                            .background(Color.white)
                            .padding(.leading, 16)

                            ZStack(alignment: .top) {
                                ForEach(scheduleItems) { item in
                                    ScheduleRow(item: item)
                                        .padding(.horizontal)
                                        .offset(y: CGFloat(timeStringToInt(item.startTime)) * 68)
                                        .padding(11)
                                        .padding(.leading, 12)
                                }

                                // Blue line indicator
                                let currentTimeY = CGFloat(timeStringToInt(currentTimeString())) * 68 + currentMinuteOffset()
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.sky)
                                        .frame(width: 260, height: 1.5)
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 8, height: 8)
                                        .offset(x: -4) // Center the circle on the line
                                }
                                .offset(y: currentTimeY)
                                .padding(.leading, 35)
                            }
                            .padding(.leading, 40)
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear.onAppear {
                                    if !initialScrollDone {
                                        let currentHour = timeStringToInt(currentTimeString())
                                        scrollViewProxy.scrollTo(currentHour, anchor: .center)
                                        initialScrollDone = true
                                    }
                                }
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < -50 {
                                        // Swiped left
                                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                                    } else if value.translation.width > 50 {
                                        // Swiped right
                                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                                    }
                                }
                        )
                    }
                    .padding(0) // Ensure no extra padding here
                }
                .onAppear {
                    scheduleItems = generateScheduleItems(selectedDate: selectedDate)
                    updateDates(for: selectedDate)
                    var calendarItems = generateScheduleItemsFromGCalendar()
                    print("onAppear: \(calendarItems) ")
                    scheduleItems.append(contentsOf: calendarItems)

                }
                .onChange(of: clasificationIdentifier){
                    scheduleItems = generateScheduleItems(selectedDate: selectedDate)
                   
                    print("clasifictionIdenfier changed")
                    var calendarItems = generateScheduleItemsFromGCalendar()
                    scheduleItems.append(contentsOf: calendarItems)
                    print("onChange \(scheduleItems) ")

                }
                .onChange(of: selectedDate) { newDate in
                    scheduleItems = generateScheduleItems(selectedDate: newDate)
                    updateDates(for: selectedDate)

                    var calendarItems = generateScheduleItemsFromGCalendar()
                    scheduleItems.append(contentsOf: calendarItems)
                    print("onChange \(calendarItems) ")
                    print(scheduleItems)
                    clasificationIdentifier = []
                    if !isDateInCurrentWeek(date: newDate) {
                        print("not date in current week")
                        print(newDate)
                        currentWeekOffset = calculateWeekOffset(from: newDate)
                        print(calculateWeekOffset(from: newDate))
                    }
                }
               
                
                .padding(0) // Ensure no extra padding here
            }
            .onAppear {
                updateDates(for: selectedDate)
            }
            .padding(0) // Ensure no extra padding here
        }
    func updateDates(for newDate: Date) {
        let timeZone = TimeZone.current
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: newDate)
        
        let startDateComponents = calendar.dateComponents(in: timeZone, from: startOfDay)
        selectedDate = calendar.date(from: startDateComponents) ?? newDate
        
        var endDateComponents = startDateComponents
        endDateComponents.hour = 23
        endDateComponents.minute = 59
        endDateComponents.second = 59
        endDate = calendar.date(from: endDateComponents) ?? newDate
    }
    
    
    
    private func isDateInCurrentWeek(date: Date) -> Bool {
           let calendar = Calendar.current
           let startOfWeek = calendar.date(byAdding: .day, value: currentWeekOffset * 7, to: startOfCurrentWeek())!
           let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
           return calendar.isDate(date, inSameDayAs: startOfWeek) || calendar.isDate(date, inSameDayAs: endOfWeek) || (date > startOfWeek && date < endOfWeek)
       }

    private func calculateWeekOffset(from date: Date) -> Int {
        let calendar = Calendar.current
        
        // Get the current date and adjust to the start of the week
        let currentDate = Date()
        let startOfCurrentWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) ?? currentDate
        
        let startOfNewDateWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
        
        // Calculate the number of weeks between startOfCurrentWeek and the given date
        
        let weeksBetween = calendar.dateComponents([.weekOfYear], from: startOfCurrentWeek, to: startOfNewDateWeek).weekOfYear ?? 0
//
//        print("Start of current week:", startOfCurrentWeek)
//        print("To date:", date)
//        print("Weeks between:", weeksBetween)

        return weeksBetween
    }

       private func startOfCurrentWeek() -> Date {
           let calendar = Calendar.current
           let now = Date()
           let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
           return calendar.date(from: components)!
       }
    
    func generateScheduleItemsFromGCalendar() -> [ScheduleItem] {
        var scheduleItems: [ScheduleItem] = []
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
        let calendar = Calendar.current
        print("call GCalendar function")

        if !clasificationIdentifier.isEmpty {
            print("GCalendar not empty")

                for index in clasificationIdentifier.indices {
                    let product = clasificationIdentifier[index]
                    let startTime = product.start != nil ? dateFormatter.string(from: product.start!) : "No Start Time"
                    let endTime = product.end != nil ? dateFormatter.string(from: product.end!) : "No End Time"
                    
                    let selectedDateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
                    
                    
                    print("start time for here", startTime)
                    print("end time for here", endTime)

                    let scheduleItem = ScheduleItem(
                        startTime: startTime,
                        endTime: endTime,
                        title: product.summary ?? "No Title",
                        details: "", // Add your details if needed
                        color: Color.lav, // Replace with your desired color
                        appsBlocked: 3, // Adjust based on your requirements
                        hasAlarm: false, // Adjust based on your requirements
                        isSuggested: true // Adjust based on your requirements
                    )
                    scheduleItems.append(scheduleItem)
                }
            }
        return scheduleItems
    }
    
    func generateScheduleItems(selectedDate: Date) -> [ScheduleItem] {
        var scheduleItems: [ScheduleItem] = []
        let center = DeviceActivityCenter()
        let activities = center.activities
        let calendar = Calendar.current

        print("Selected Date:", selectedDate)

        for activity in activities {
            if let schedule = center.schedule(for: activity) {
                let intervalStart = schedule.intervalStart
                let intervalEnd = schedule.intervalEnd

                print("Activity:", activity.rawValue)
                print("Interval Start:", intervalStart)
                print("Interval End:", intervalEnd)

                // Create date components from selectedDate
                let selectedDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())

                // Combine selectedDate's components with intervalStart's time components
                var combinedComponents = DateComponents()
                combinedComponents.year = selectedDateComponents.year
                combinedComponents.month = selectedDateComponents.month
                combinedComponents.day = selectedDateComponents.day
                combinedComponents.hour = intervalStart.hour
                combinedComponents.minute = intervalStart.minute

                // Create a date from combined components
                if let scheduledDate = calendar.date(from: combinedComponents) {
                    print("Scheduled Date:", scheduledDate)

                    // Compare if the scheduled date is on the same day as selectedDate
                    if calendar.isDate(selectedDate, inSameDayAs: scheduledDate) {
                        print("Match found for selectedDate:", selectedDate)

                        // Perform your logic here if the dates match
                        if let startTime = formatTime(from: intervalStart),
                           let endTime = formatTime(from: intervalEnd) {

                            let scheduleItem = ScheduleItem(
                                startTime: startTime,
                                endTime: endTime,
                                title: activity.rawValue,
                                details: "", // Add your details if needed
                                color: Color.blue, // Replace with your desired color
                                appsBlocked: 3, // Adjust based on your requirements
                                hasAlarm: false, // Adjust based on your requirements
                                isSuggested: false // Adjust based on your requirements
                            )

                            // Add the scheduleItem to the array
                            scheduleItems.append(scheduleItem)
                        }
                    }
                }
            }
        }

        print("Final Schedule Items:", scheduleItems)

        return scheduleItems
    }

    func formatTime(from components: DateComponents) -> String? {
        // Create a DateFormatter to format the time
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short

        // Create a base date (e.g., today's date) to combine with components
        let baseDate = Date()

        // Convert DateComponents to Date
        if let date = Calendar.current.date(from: components) {
            // Format the Date to string
            let dateString = dateFormatter.string(from: date)
            return dateString
        } else {
            return nil
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
struct WeeklySnapScrollView: View {
    @State private var isShowingDatePicker = false
    @Binding var selectedDate: Date // Binding for selected date
    @Binding var currentWeekOffset: Int

    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing:0) {
                selectedMonthYearText(for: weekStartDate(for: currentWeekOffset))
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                
                TabView(selection: $currentWeekOffset) {
                    ForEach(-52...52, id: \.self) { offset in
                        let weekStartDate = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: startOfCurrentWeek)!
                        WeeklyView(selectedDate: $selectedDate, weekStartDate: weekStartDate)
                            .tag(offset)
                    }
                }
                .frame(height: 100)
                .padding(0)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentWeekOffset) { newValue in
                    var newDate = Calendar.current.date(byAdding: .weekOfYear, value: newValue, to: startOfCurrentWeek) ?? Date()
                    if Calendar.current.component(.weekday, from: newDate) == 1 {
                        newDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate) ?? newDate
                    }
                    if !isDateInCurrentWeek(date: newDate) {
                                   currentWeekOffset = calculateWeekOffset(from: newDate)
                               }
//                    selectedDate = newDate
                }
            }
            HStack() {
//                Button(action: {
//                    currentWeekOffset -= 1
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.black)
//                }
                
                Button(action: {
                    isShowingDatePicker.toggle()
                }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $isShowingDatePicker) {
                    CalendarPicker(selectedDate: $selectedDate, currentWeekOffset: $currentWeekOffset)
                }
                
//                Text("\(selectedMonthDateText(for: selectedDate))")
//                    .font(.subheadline)
//                    .foregroundColor(.black)
                
//                Button(action: {
//                    currentWeekOffset += 1
//                }) {
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.black)
//                }
            }
            .padding(0)
        }
    }
    private func isDateInCurrentWeek(date: Date) -> Bool {
           let calendar = Calendar.current
           let startOfWeek = calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: startOfCurrWeek())!
           let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        print(calendar.isDate(date, inSameDayAs: startOfWeek) || calendar.isDate(date, inSameDayAs: endOfWeek) || (date > startOfWeek && date < endOfWeek))
           return calendar.isDate(date, inSameDayAs: startOfWeek) || calendar.isDate(date, inSameDayAs: endOfWeek) || (date > startOfWeek && date < endOfWeek)
       }

       private func calculateWeekOffset(from date: Date) -> Int {
           let calendar = Calendar.current
           let startOfCurrentWeek = self.startOfCurrWeek()
           let weeksBetween = calendar.dateComponents([.weekOfYear], from: startOfCurrentWeek, to: date).weekOfYear ?? 0
           return weeksBetween
       }
    private func startOfCurrWeek() -> Date {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
            return calendar.date(from: components)!
        }
    var startOfCurrentWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return calendar.date(from: components) ?? Date()
    }
    
    func selectedMonthDateText(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: date)
    }
    func weekStartDate(for offset: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: offset, to: startOfCurrentWeek) ?? Date()
    }
    func selectedMonthYearText(for date: Date) -> some View {
        let month = Text(date, formatter: monthFormatter)
            .font(.subheadline)
            .bold()
            .foregroundColor(.black)
        let year = Text(date, formatter: yearFormatter)
            .font(.subheadline)
            .foregroundColor(.black)
        
        return Text("\(month) \(year)")
    }

    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()

    private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
}


struct WeeklyView: View {
    @Binding var selectedDate: Date
    let weekStartDate: Date

    var body: some View {
        let days = daysInWeek(for: weekStartDate)

        HStack(spacing: 10) {
            ForEach(days, id: \.self) { date in
                VStack {
                    Text(dayOfWeek(for: date))
                        .font(.caption)
                    Text("\(dayOfMonth(for: date))")
                        .font(.headline)
                }
                .padding()
                .background(
                    Group {
                        if isSameDay(date1: date, date2: selectedDate) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.black)
                        } else if isToday(date: date) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(selectedDate == date ? Color.black : Color.babyBlue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.mauve, style: StrokeStyle(lineWidth: 3, dash: [5]))
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.clear)
                        }
                    }
                )
                .foregroundColor(
                    isSameDay(date1: date, date2: selectedDate) ? Color.white : Color.black
                )
                .cornerRadius(10)
                .onTapGesture {
                    selectedDate = date
                }
            }
        }
        .padding(.horizontal)
    }

    func daysInWeek(for startDate: Date) -> [Date] {
        var days: [Date] = []
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: startDate)?.start ?? startDate

        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(day)
            }
        }
        return days
    }

    func dayOfWeek(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }

    func dayOfMonth(for date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }

    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
}


struct CalendarPicker: View {
    @Binding var selectedDate: Date
    @Binding var currentWeekOffset: Int

    var body: some View {
        VStack(alignment: .trailing) {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: selectedDate) { _ in
                    let calendar = Calendar.current
                    let currentDate = calendar.startOfDay(for: Date())
                    let selectedStartOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start ?? selectedDate
                    let currentStartOfWeek = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.start ?? currentDate
                    let weeksOffset = calendar.dateComponents([.weekOfYear], from: currentStartOfWeek, to: selectedStartOfWeek).weekOfYear ?? 0
                    currentWeekOffset = weeksOffset
                }
        }
    }
}
