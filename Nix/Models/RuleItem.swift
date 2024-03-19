//
//  RuleItem.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import Foundation

struct RuleItem: Codable, Identifiable {
    let id: String
    let title: String
    let startTime: TimeInterval
    let endTime: TimeInterval
    let selectedDays: [Int]
   
}
