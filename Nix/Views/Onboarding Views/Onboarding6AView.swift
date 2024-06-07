//
//  Onboarding6AView.swift
//  Nix
//
//  Created by Grace Yang on 6/4/24.
//

import SwiftUI

struct Onboarding6AView: View {
    @Binding var weeks: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("The suggested time frame is 8 weeks, but we trust your judgment. You can always change it back in the settings.")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.leading, 15)
                    .padding(.top, 20)
                Spacer()
            }
            
            HStack(spacing: 40) {
                Button(action: {
                    if weeks > 1 {
                        weeks -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                }
                Text("\(String(format: "%02d", weeks))")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                Button(action: {
                    if weeks < 52 {
                        weeks += 1
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                }
                Text("weeks")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 40)
        }
        .padding()
        .navigationBarHidden(true)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}


struct Onboarding6AView_Previews: PreviewProvider {
    @State static var weeks: Int = 8

    static var previews: some View {
        Onboarding6AView(weeks: $weeks)
    }
}
