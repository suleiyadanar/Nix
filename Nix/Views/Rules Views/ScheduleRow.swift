//
//  ScheduleRow.swift
//  Nix
//
//  Created by Grace Yang on 6/29/24.
//

import SwiftUI

struct ScheduleRow: View {
    var item: ScheduleItem
    
    var body: some View {
        VStack (alignment: .leading){
            ZStack {
                
                // Color tag on the left
                HStack {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 15.0,
                        bottomLeading: 15.0,
                        bottomTrailing: 0,
                        topTrailing: 0),
                                           style: .continuous)
                    .fill(item.color)
                    .frame(width: 13, height: item.duration * 63)
                    Spacer()
                }
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.title)
                            .padding(.bottom, 2)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(item.formattedTime)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(item.appsBlocked) apps blocked")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 15)
                    
                }
                
            }
            .frame(width: 280, height: item.duration * 63) // Control the height based on duration
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 5, y: 5)
            )
            .padding(.bottom, 5)


        }
    }
}


#Preview {
    SuggestRow(title: "Club Meeting", time: "7:00pm - 8:00pm", appsBlocked: 3, color: Color.sky)
}
