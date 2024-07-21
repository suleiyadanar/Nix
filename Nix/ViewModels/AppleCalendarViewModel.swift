//
//  AppleCalendarViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/20/24.
//

import Foundation
import EventKit
import SwiftUI

class AppleCalendarViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var authorizationError: Error?
    @Published var isCalendarSynced: Bool = false
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    
    func requestAccessToCalendar() async {
        do {
            if #available(iOS 17, *) {
                let access = try await eventStore.requestFullAccessToEvents()
                isCalendarSynced = access // Set sync status based on the result
            } else {
                let access = try await eventStore.requestAccess(to: .event)
                isCalendarSynced = access // Set sync status based on the result
            }
        } catch {
            isCalendarSynced = false // Set sync status to false if an error occurs
        }
    }
    
    func getAllEventsForToday() async -> [ScheduleItem] {
        var scheduleItems : [ScheduleItem] = []
        print("fetchign apple calenar", startDate, endDate)
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
       
       
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
            let allEvents = eventStore.events(matching: eventsPredicate)
            for event in allEvents {
                        let startTime = dateFormatter.string(from: event.startDate)
                        let endTime = dateFormatter.string(from: event.endDate)
                        
                        let scheduleItem = ScheduleItem(
                            startTime: startTime,
                            endTime: endTime,
                            title: event.title ?? "No Title",
                            details: event.notes ?? "", // Use event notes for details
                            color: Color.lav, // Set the desired color
                            appsBlocked: 3, // Adjust based on your requirements
                            hasAlarm: false, // Adjust based on your requirements
                            isSuggested: true // Adjust based on your requirements
                        )
                        
                        scheduleItems.append(scheduleItem)
                    }
            
        
        return scheduleItems
    }
}
