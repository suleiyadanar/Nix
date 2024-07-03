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
   let id: String
   let title: String
   let startTime: TimeInterval
   let endTime: TimeInterval
   let fromDate: TimeInterval
   let toDate: TimeInterval
   let selectedDays: [Int]
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
