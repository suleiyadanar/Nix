//
//  ScheduleItem.swift
//  Nix
//
//  Created by Grace Yang on 6/29/24.
//

import SwiftUI

struct ScheduleItem: Identifiable {
    let id = UUID()
    let startTime: String
    let endTime: String
    let title: String
    let details: String
    let color: Color
    let appsBlocked: Int

    var duration: Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            return 0
        }
        return end.timeIntervalSince(start) / 3600
    }

    var formattedTime: String {
        return "\(startTime) - \(endTime)"
    }
}
