//
//  CustomDatePickerView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/6/24.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    @State private var currentMonth: Int
    @State private var currentYear: Int
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter
    private let years: [Int] = Array(1900...2018)
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let currentDate = selectedDate.wrappedValue
        self._currentMonth = State(initialValue: calendar.component(.month, from: currentDate))
        self._currentYear = State(initialValue: calendar.component(.year, from: currentDate))
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(dateFormatter.string(from: calendar.date(from: DateComponents(year: currentYear, month: currentMonth))!))
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            Picker("Year", selection: $currentYear) {
                ForEach(years, id: \.self) { year in
                    Text("\(year)").tag(year)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            let days = generateDays()
            let rows = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: rows, spacing: 10) {
                ForEach(days.indices, id: \.self) { index in
                    let date = days[index]
                    Text(date == nil ? "" : String(calendar.component(.day, from: date!)))
                        .padding()
                        .background(date != nil && calendar.isDate(date!, inSameDayAs: selectedDate) ? Color.blue : Color.clear)
                        .foregroundColor(date != nil && calendar.isDate(date!, inSameDayAs: selectedDate) ? Color.white : Color.primary)
                        .clipShape(Circle())
                        .onTapGesture {
                            if let date = date {
                                selectedDate = date
                            }
                        }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding()
    }
    
    private func previousMonth() {
        if currentMonth == 1 {
            currentMonth = 12
            currentYear -= 1
        } else {
            currentMonth -= 1
        }
    }
    
    private func nextMonth() {
        if currentMonth == 12 {
            currentMonth = 1
            currentYear += 1
        } else {
            currentMonth += 1
        }
    }
    
    private func generateDays() -> [Date?] {
        guard let monthStart = calendar.date(from: DateComponents(year: currentYear, month: currentMonth)) else {
            return []
        }
        
        var days: [Date?] = Array(repeating: nil, count: calendar.component(.weekday, from: monthStart) - 1)
        if let range = calendar.range(of: .day, in: .month, for: monthStart) {
            for day in range {
                days.append(calendar.date(byAdding: .day, value: day - 1, to: monthStart))
            }
        }
        return days
    }
}
