//
//  SuggestRow.swift
//  Nix
//
//  Created by Grace Yang on 6/29/24.
//

import SwiftUI

struct SuggestRow: View {
    var title: String
    var time: String
    var appsBlocked: Int
    var color: Color

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                // Color tag on the left
                HStack {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 15.0,
                        bottomLeading: 15.0,
                        bottomTrailing: 0,
                        topTrailing: 0),
                                           style: .continuous)
                        .fill(color)
                        .frame(width: 13)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(title)
                            .padding(.bottom, 2)
                        Spacer()
                        
                        Button(action: {
                            // Add action
                        }) {
                            HStack {
                                Text("Add")
                                    .font(.caption)
                                    .foregroundStyle(Color.mauve)
                                    .offset(x: 1)
                                Image(systemName: "plus.circle")
                                    .font(.headline)
                                    .foregroundColor(.mauve)
                                    .offset(x: -1)
                            }
                            .padding(.leading, 5)
                            .padding(.horizontal, 8)
                            .background(Color.lemon)
                            .cornerRadius(20)
                        }
                    }
                    Spacer()
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

                }
                .padding(7)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.leading, 20)
                .padding(.trailing, 2)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.15), radius: 7, x: 5, y: 5)
        )
        .padding(.bottom, 5)
        .padding(.trailing, 5)
        .padding(.leading, 7)
        .safeAreaInset(edge: .trailing) { // Adjust content to ignore trailing safe area (scroll indicator)
                    Color.clear.frame(width: 0)
                }
    }
}


#Preview {
    SuggestRow(title: "Club Meeting", time: "7:00pm - 8:00pm", appsBlocked: 3, color: Color.sky)
}
