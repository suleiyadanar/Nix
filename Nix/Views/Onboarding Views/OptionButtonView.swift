// OptionButtonView.swift
// Nix
// Created by Grace Yang on 6/2/24.

import SwiftUI

struct OptionButtonView: View {
    var props: Properties

    @Binding var isSelected: Bool
    var inputText: String
    var onSelectionChange: (Bool) -> Void
    var fontSize: CGFloat
    
    var body: some View {
        Button(action: {
            self.isSelected.toggle()
            self.onSelectionChange(self.isSelected)
        }) {
            ZStack {
                Rectangle()
                    .fill(isSelected ? Color.sky : Color.lightGray)
                    .frame(width: props.isIPad ? 200 : 140, height:  props.isIPad ? 150 : 80) // Ensure size consistency
                    .cornerRadius(10)
                VStack(alignment: .center) {
                    Spacer()
                    Text(inputText)
                        .padding(.horizontal, 15)
                        .font(.custom("Montserrat-Regular", size: fontSize))
                        .foregroundColor(isSelected ? Color.white : Color.black)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .frame(width: props.isIPad ? 200 : 140, height:  props.isIPad ? 150 : 80)
        .buttonStyle(PlainButtonStyle())
    }
}
//
//struct OptionButtonView_Previews: PreviewProvider {
//    struct Wrapper: View {
//        @State var isSelected = false
//        
//        var body: some View {
//            OptionButtonView(isSelected: $isSelected, inputText: "Hello!", onSelectionChange: { _ in })
//        }
//    }
//    
//    static var previews: some View {
//        Wrapper()
//    }
//}
