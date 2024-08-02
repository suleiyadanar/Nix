//
//  MessageBoxView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/31/24.
//

import SwiftUI

struct MessageBoxView: View {
    var props: Properties
    var question: String
    var options: [String]
    @Binding var selectedOption: Int // Bind the selected option
    var onArrowButtonPressed: () -> Void
    var onOptionSelected: (Int) -> Void // Closure to handle option selection
    var result: String? // Optional result to display
    @Environment(\.colorScheme) var colorScheme

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
                if let result = result {
                    VStack{
                        Text(result)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                            .padding(.top, 20)
                            .padding()
                        Image("\(result)-still")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:props.isIPad ? 300 : 150)
                            .padding()
                            .background(Color.clear)
                    }
                } else {
                    Text(question)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                        .padding(.top, 20)
                        .padding()

                    // Radio buttons
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(options.indices, id: \.self) { index in
                            RadioButton(text: options[index], isSelected: selectedOption == index) {
                                selectedOption = index
                                onOptionSelected(index) // Call the closure when an option is selected
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }

                Spacer()

                Button(action: {
                    onArrowButtonPressed()
                }) {
                    ArrowButtonView(props: props)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                }
                .padding(.bottom, 20)
            }
            .frame(width: props.isIPad && !props.isSplit ? props.width * 0.5 : props.width * 0.8, height: props.isIPad ? props.height * 0.5 : props.height * 0.8)
            .background(colorScheme == .dark ? Color.black : Color.white)
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
