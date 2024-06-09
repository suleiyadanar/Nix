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
    let selectedDays: [Int]
    let selectedApps: String
    var selectedData: String
    var selectionType: String
}
