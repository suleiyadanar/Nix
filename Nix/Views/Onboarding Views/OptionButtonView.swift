// OptionButtonView.swift
// Nix
// Created by Grace Yang on 6/2/24.

import SwiftUI

struct OptionButtonView: View {
    @Binding var isSelected: Bool
    var inputText: String
    var onSelectionChange: (Bool) -> Void

    var body: some View {
        Button(action: {
            self.isSelected.toggle()
            self.onSelectionChange(self.isSelected)
        }) {
            ZStack {
                Rectangle()
                    .fill(isSelected ? Color.lemon : Color.lightGray)
                    .frame(width: 300, height: 45)
                    .cornerRadius(10)
                VStack {
                    Spacer()
                    Text(inputText)
                        .padding(.leading, 15)
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OptionButtonView_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var isSelected = false
        
        var body: some View {
            OptionButtonView(isSelected: $isSelected, inputText: "Hello!", onSelectionChange: { _ in })
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
