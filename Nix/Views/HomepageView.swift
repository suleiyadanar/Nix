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
    
    private let today = Date()
    private let userId: String
   
    
    init(userId: String){
        self.userId = userId
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
                
                DeviceActivityReport(context, filter: filter)
                
                // Screen Time Data
                VStack(alignment:.leading){
                        Text("Today's Screen Time").font(.body)
                        Text("1hr 52mins").font(.title3).fontWeight(.heavy)
                        Label("Expert", systemImage:"heart.fill").padding(.bottom,10)
                    HStack{
                        Text("Quick Start").font(.subheadline).fontWeight(.heavy)
                        Spacer()
                        NavigationLink("Show All>", destination: RulesView(userId: userId))
                    }
                  
                    VStack(){
                        HStack(){
                            QuickStartBtnView(time: "25 min", rule: "Me Time", iconName:  "person")
                            Spacer()
                            QuickStartBtnView(time: "25 min", rule: "Me Time", iconName:  "person")
                        }.padding(.vertical,20)
                        HStack(){
                            QuickStartBtnView(time: "25 min", rule: "Me Time", iconName:  "person")
                            Spacer()
                            QuickStartBtnView(time: "25 min", rule: "Me Time", iconName:  "person")
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.horizontal, 20)
                   
                    
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
