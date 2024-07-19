//
//  CalendarView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/22/24.
//

import SwiftUI

struct CalendarView: View {
    @State var isPresented = false
    @State var clasificationIdentifier : [CalendarEvent]  = [CalendarEvent]()
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    let hourHeight = 50.0
    let today = Date()
  
    
        var body: some View {
            
                  
            VStack {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                               .onChange(of: startDate) { newDate in
                                   updateDates(for: newDate)
                               }
                           
                           // Display Start and End Date/Time
                           Text("Start Date: \(startDate.formatted())")
                           Text("End Date: \(endDate.formatted())")
                if clasificationIdentifier.count == 0 {
                    ViewControllerRepresentableView(
                                   identifier: $clasificationIdentifier,
                                   startDateTime: startDate,
                                   endDateTime: endDate
                               )
                }else{
                    VStack(alignment: .leading) {
                        // Date headline
                        if clasificationIdentifier.count > 0 {
                            VStack {
                                ScrollView{
                                    ForEach(0...clasificationIdentifier.count-1, id:\.self){count in
                                        let product = clasificationIdentifier[count]
                                        eventCell(product).background(alignment: .leading){
                                            Rectangle().frame(width: 1).offset(x:8)
                                                .padding(.bottom, -35)
                                        }.padding(.vertical,10)
                                        
                                    }
                                }
                            }
                        }
                        
                        
                    }
            }
            }
            .onAppear {
                       updateDates(for: startDate)
                   }
            
        }
    
    func updateDates(for newDate: Date) {
        let timeZone = TimeZone.current
        let startOfDay = Calendar.current.startOfDay(for: newDate)
        
        // Convert to current time zone
        let startDateComponents = Calendar.current.dateComponents(in: timeZone, from: startOfDay)
        startDate = Calendar.current.date(from: startDateComponents) ?? newDate
        
        // Set end of the day
        var endDateComponents = startDateComponents
        endDateComponents.hour = 23
        endDateComponents.minute = 59
        endDateComponents.second = 59
        endDate = Calendar.current.date(from: endDateComponents) ?? newDate
    }
    
    func eventCell(_ event: CalendarEvent) -> some View {
        return  AnyView (
            HStack(alignment: .top, spacing: 15){
                Circle()
                    .fill(.blue)
                    .frame(width: 10, height: 10)
                    .padding(4)
                    .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in:.circle)
                VStack(alignment: .leading, spacing: 8, content: {
                    Text(event.summary ?? "").bold()
                    Label("\(event.start?.formatted(.dateTime.hour().minute()) ?? "")-\(event.end?.formatted(.dateTime.hour().minute()) ?? "")", systemImage: "clock").font(.caption).foregroundStyle(.black)
                    Spacer().frame(maxWidth:.infinity)
                })
                .padding(15)
                .background(.blue, in: .rect(cornerRadius: 15))
                .offset(y:-8)
            }
        )
    }
}


#Preview {
    CalendarView()
}
