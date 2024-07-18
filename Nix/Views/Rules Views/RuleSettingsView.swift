//
//  RuleSettingsView.swift
//  Nix
//
//  Created by Grace Yang on 7/16/24.
//

import SwiftUI

struct RuleSettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
               
        HStack {
           Image("new-rule-icon")
           Text("Morning Me-Time")
               .font(.system(size: 20))
               .bold()
           Spacer()
           Button(action: {}) {
               Image(systemName: "xmark")
                   .foregroundColor(.gray)
           }
        }
            
        HStack {
            VStack {
                HStack {
                    Text("Blocked Apps")
                        .font(.headline)
                    Spacer()
                }
                HStack {
                    Text("Distracting Apps")
                    Text("10 apps blocked")
                        .font(.subheadline)
                    Spacer()
                    
                }
            }
            Button(action: {}) {
                Image("pencil-icon")
            }
        }
        .padding()
        .background(Color.mango)
        .cornerRadius(8)



        HStack {
           Text("Start Time")
               .font(.headline)
           Spacer()
           HStack {
               Text("08:00")
                   .padding(2)
                   .background(Color.lemon)
                   .foregroundStyle(Color.white)
                   .cornerRadius(8)
               Text("AM")
                   .padding(2)
                   .background(Color.purple.opacity(0.2))
                   .cornerRadius(8)
               Text("PM")
                   .padding(2)
                   .background(Color.gray.opacity(0.2))
                   .cornerRadius(8)
           }
        }

        HStack {
           Text("End Time")
               .font(.headline)
           Spacer()
           HStack {
               Text("10:00")
                   .padding(2)
                   .background(Color.lemon)
                   .foregroundStyle(Color.white)
                   .cornerRadius(8)
               Text("AM")
                   .padding(2)
                   .background(Color.purple.opacity(0.2))
                   .cornerRadius(8)
               Text("PM")
                   .padding(2)
                   .background(Color.gray.opacity(0.2))
                   .cornerRadius(8)
           }
        }



        HStack {
           Text("All Day")
               .font(.headline)
           Spacer()
           Toggle("", isOn: .constant(false))
               .labelsHidden()
        }
            
        Image("line-divider")
           
        Text("Mode")
           .font(.headline)
        HStack {
           Text("Regular")
               .padding()
               .background(Color.gray.opacity(0.2))
               .cornerRadius(8)
           Text("Intentional")
               .padding()
               .background(Color.yellow)
               .cornerRadius(8)
           Text("Strict")
               .padding()
               .background(Color.gray.opacity(0.2))
               .cornerRadius(8)
        }

        HStack {
            Text("Remind Me Every:")
                .font(.headline)
            Spacer()
            HStack {
                Text("0")
                    .padding(2)
                    .background(Color.yellow)
                    .cornerRadius(8)
                Text("hr")
                Text("20")
                    .padding(2)
                    .background(Color.yellow)
                    .cornerRadius(8)
                Text("min")
            }
        }
               
               
           HStack {
               ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                   Text(day)
                       .padding()
                       .background(Color.gray.opacity(0.2))
                       .cornerRadius(8)
               }
           }
           
           Spacer()
           
           Button(action: {}) {
               Text("SAVE")
                   .padding()
                   .frame(maxWidth: .infinity)
                   .background(Color.purple)
                   .cornerRadius(8)
                   .foregroundColor(.white)
           }
        }
        .padding()
    }
}

#Preview {
    RuleSettingsView()
}
