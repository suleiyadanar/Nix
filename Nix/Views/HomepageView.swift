//
//  HomepageView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/18/24.
//
import SwiftUI
import DeviceActivity
    
    struct HomepageView: View {
        
        @Environment(\.colorScheme) var colorScheme
        @StateObject var viewModel = HomepageViewViewModel()
        
        @State var settingsView: Bool = false
        @State private var selection = 0

        
        private let today = Date()
        private let userId: String
       
        
        private var currentWeekInterval: DateInterval {
            guard let startOfWeek = Calendar.current.dateInterval(of: .weekOfYear, for: today)?.start else {
                fatalError("Failed to calculate start of the week")
            }
            
            let endOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: startOfWeek)!
            
            return DateInterval(start: endOfWeek, end: startOfWeek)
        }

        @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total ScreenTime")

        @State private var filter = DeviceActivityFilter(
            segment: .daily(
            during: Calendar.current.dateInterval(
            of: .day, for: .now
                )!
            ),
            users: .all,
            devices: .init([.iPhone, .iPad])
        )

        private var weeklyFilter: DeviceActivityFilter {
            DeviceActivityFilter(
                segment: .weekly(during: currentWeekInterval),
                users: .all,
                devices: .init([.iPhone, .iPad])
            )
        }
        private func tabText(for index: Int) -> String {
                switch index {
                case 0:
                    return "Today's Screen Time"
//                case 1:
//                    return "Weekly Average"
                
                default:
                    return "Tab \(index + 1)"
                }
            }
        
        init(userId: String){
            self.userId = userId
            UIPageControl.appearance().currentPageIndicatorTintColor = .green
                        UIPageControl.appearance().pageIndicatorTintColor = UIColor.green.withAlphaComponent(0.2)
        }
        
        var body: some View {
            
            NavigationView {
                VStack(alignment:.leading) {
                    Text("Good Morning, Su Lei!").font(.title)
                    // Today's Date
                    HStack {
                        Text(today.formatted(.dateTime.day().month()))
                            .bold()
                        Text(today.formatted(.dateTime.year()))
                    }
                    .font(.title)
                    
                    
                    // Screen Time Data
                    VStack(alignment:.leading){
                        Text("Today's Screen Time").font(.body)
                        
                            Picker(selection: $selection, label: Text("Picker")) {
                                            Text("Daily").tag(0)
                                            Text("Weekly").tag(1)
                                            // Add more segments as needed
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        
                                        // Show views based on selection
                                        if selection == 0 {
                                            DeviceActivityReport(context, filter:
                                                                    filter)
                                        } else if selection == 1 {
                                            DeviceActivityReport(context, filter:
                                                                    weeklyFilter)                                        }
                           
                       
//                        .tint(Color.red)
                                            Label("Expert", systemImage:"heart.fill").padding(.bottom,10)
                        HStack{
                            Text("Quick Start").font(.subheadline).fontWeight(.heavy)
                            Spacer()
                            NavigationLink("Show All>", destination: RulesView(userId: userId))
                        }
                        
                        VStack (alignment:.leading){
                            Text("Today's Schedule")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .padding(.vertical, 20)
                           
                            CalendarView()
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                }
                .toolbar {
                    Button {
                        self.settingsView = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                }.padding(0)
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $settingsView) {
                SettingsView()
            }
        }
    }

//#Preview {
//    HomepageView(userId: "")
//}

