//
//  MessageBoxView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/31/24.
//

import SwiftUI

struct MessageBoxView: View {
    var props: Properties
    @State private var selectedOption = 1

    var body: some View {
        VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        // Title bar with close, minimize, maximize buttons
                        HStack {
                            Circle()
                                .foregroundColor(Color.red)
                                .frame(width: 10, height: 10)
                            Circle()
                                .foregroundColor(Color.yellow)
                                .frame(width: 10, height: 10)
                            Circle()
                                .foregroundColor(Color.green)
                                .frame(width: 10, height: 10)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.orange)
                        
                        // Main content
                                       Text("How do you prefer to start your day?")
                                           .font(.custom("Courier", size: 16))
                                           .padding(.top, 20)
                        // Radio buttons
                        VStack(alignment:.leading, spacing: 15) {
                                            RadioButton(text: "Planning tasks and setting goals", isSelected: selectedOption == 1) {
                                                selectedOption = 1
                                            }
                                            RadioButton(text: "Calm routine, meditation or walk", isSelected: selectedOption == 2) {
                                                selectedOption = 2
                                            }
                                            RadioButton(text: "Diving into work with focus", isSelected: selectedOption == 3) {
                                                selectedOption = 3
                                            }
                                            RadioButton(text: "High energy and enthusiasm", isSelected: selectedOption == 3) {
                                                selectedOption = 3
                                            }
                                        }
                                        .padding(.vertical, 20)
                                        
                        Spacer()
                        
                        Button(action: {
                            // Add your button action here
                        }) {
                            Text("OK")
                                .font(.custom("Courier", size: 14))
                                .frame(width: 60, height: 30)
                                .background(Color.pink)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(width: 400, height: 350)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
               
            }
}

struct RadioButton: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(Color.babyBlue)
                            .frame(width: 10, height: 10)
                    }
                }
                Text(text)
                    .font(.custom("Courier", size: 14))
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 5)
    }
}
#Preview {
    MessageBoxView()
}
