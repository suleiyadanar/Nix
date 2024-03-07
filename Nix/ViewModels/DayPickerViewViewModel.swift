//
//  DayPickerViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/28/24.
//

import Foundation


func specifiedDate() -> [Date] {
    var calendar = Calendar.current
    var dateComponents = DateComponents()
    var dayOfWeek : [Date] = []
    
    dateComponents.year = 2024
    dateComponents.month = 2
    dateComponents.day = 26
    
    var monday = calendar.date(from: dateComponents)!
    
    for day in 0..<7 {
        var newDate = calendar.date(byAdding: .day, value: day, to: monday)!    }
    return dayOfWeek

}
