//
//  ColorSwatchView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/3/24.
//

import SwiftUI

struct ColorSwatchView: View {

    @Binding var selection: String

    var body: some View {

        let swatches = [
            "swatch_lemon",
            "swatch_mango",
            "swatch_poppy",
            "swatch_baby_blue",
            "swatch_sky",
            "swatch_lavender",
            "swatch_bubble",
            "swatch_mauve",
//            "swatch_forest",
        ]

        let columns = [
            GridItem(.adaptive(minimum: 40))
        ]

        LazyVGrid(columns: columns) {
            ForEach(swatches, id: \.self) { swatch in
                ZStack {
                    Circle()
                        .fill(Color(swatch))
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            selection = swatch
                        }
                        
                       

                    if selection == swatch {
                        Circle()
                            .stroke(Color(swatch), lineWidth: 4)
                            .frame(width: 50, height: 50)
                    }
                }.padding(20)
            }
        }
    }
}

struct ColorSwatchView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSwatchView(selection: .constant("swatch_shipcove"))
    }
}
