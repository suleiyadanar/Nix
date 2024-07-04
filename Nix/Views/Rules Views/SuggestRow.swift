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
                    HStack(alignment: .top) {
                        Text(title)
                            .padding(.bottom, 2)
                        Spacer()
                        
                        Button(action: {
                            // Add action
                        }) {
                          
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .foregroundColor(.lemon)
                            
//
                            
                        }
                    }
                    Spacer(minLength: 35)
                    HStack {
                        Image(systemName: "clock")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        Text(time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                }
                .frame(minHeight:90, maxHeight:90)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
//        .padding(.trailing, 5)
//        .padding(.leading, 7)
        .safeAreaInset(edge: .trailing) { // Adjust content to ignore trailing safe area (scroll indicator)
                    Color.clear.frame(width: 0)
                }
    }
}


#Preview {
    SuggestRow(title: "Club Meeting", time: "7:00pm - 8:00pm", appsBlocked: 3, color: Color.sky)
}
