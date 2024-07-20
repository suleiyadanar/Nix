//
//  CalendarModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/22/24.
//

import Foundation

struct CalendarEvent: Equatable {
    let id = UUID()
    let summary: String?
    let start: Date?
    let startTime: String?
    let startTimeOfDay : String?
    let end: Date?
    let endTime: String?
    let endTimeOfDay : String?
}
