//
//  RuleRow.swift
//  Nix
//
//  Created by Grace Yang on 6/29/24.
//

import SwiftUI

struct RuleRow: View {
    var title: String
    var time: String
    var days: String
    var color: Color
    var appsBlocked: Int

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                // Color tag on the left
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(title)
                            .font(.system(size: 16))
                            .padding(.bottom, 2)
                        Spacer()
                        if !days.isEmpty {
                            HStack(spacing: 5) {
                                ForEach(days.split(separator: " "), id: \.self) { day in
                                    Text(String(day))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(Color.babyBlue)
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }

                    Spacer(minLength: 15)
                    HStack {
                        Image(systemName: "clock")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        Text(time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(appsBlocked) apps blocked")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 2)

                }
                .padding(7)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.leading, 17)
                .frame(minHeight: 60)
            }
        }
       
//        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .padding(.bottom, 5)
        .padding(.top, 5)
        .padding(.trailing, 5)
//        .padding(.leading, 7)
        .safeAreaInset(edge: .trailing) { // Adjust content to ignore trailing safe area (scroll indicator)
                    Color.clear.frame(width: 0)
                }
    }
}

#Preview {
    RuleRow(title: "Morning Me-Time", time: "8:00pm - 9:00am", days: "Weekdays", color: Color.bubble, appsBlocked: 10)
}
