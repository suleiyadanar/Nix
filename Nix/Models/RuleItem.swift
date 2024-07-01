//
//  RuleItem.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import Foundation
import FamilyControls
import ManagedSettings

struct RuleItem: Codable, Identifiable {
   var id: String
   var title: String
   var startTime: TimeInterval
   var endTime: TimeInterval
   var fromDate: TimeInterval
   var toDate: TimeInterval
   var selectedDays: [Int]
   var selectedApps: String
   var selectedData: String
   var selectionType: String
   var mode: String
   var unlock: String
   var delay: Int
   var timeOutLength: Int
   var timeOutAllowed: Int
   var intentionalMinutes : Int
   var intentionalHours : Int
}
