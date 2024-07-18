//
//  RuleSettingsView.swift
//  Nix
//
//  Created by Grace Yang on 7/16/24.
//

import SwiftUI

struct RuleSettingsView: View {
    @State private var startIsAM = true
    @State private var endIsAM = true
    @State private var selectedMode: String? = nil
    @State private var isAllDay = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image("new-rule-icon")
                Text("Morning Me-Time")
                    .font(.system(size: 25))
                Spacer()
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 10)
            
            HStack {
                VStack (spacing: 5){
                    HStack {
                        Text("Blocked Apps")
                            .font(.system(size:15))
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    HStack {
                        Text("Distracting Apps")
                            .font(.system(size: 15))
                        Text("10 apps blocked")
                            .font(.system(size: 12))
                        Spacer()
                        
                    }
                }
                Button(action: {}) {
                    Image("pencil-icon")
                }
            }
            .padding(13)
            .background(Color.mango)
            .cornerRadius(8)
            .padding(.bottom, 5)
            
            
            HStack {
                Text("Start Time")
                    .font(.headline)
                Spacer()
                
                HStack {
                    Text("08:00")
                        .font(.system(size: 20))
                        .padding(4)
                        .frame(width: 70, height: 41)
                        .background(Color.lemon)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    ZStack(alignment: startIsAM ? .leading : .trailing) {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: 70, height: 45)
                            Color.clear.frame(width: 70, height: 45)
                        }
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lav)
                            .frame(width: 65, height: 40)
                            .padding(3)
                            .animation(.easeInOut(duration: 0.3), value: startIsAM)
                        HStack(spacing: 0) {
                            Text("AM")
                                .foregroundColor(startIsAM ? .white : .black)
                                .frame(width: 70, height: 45)
                                .onTapGesture {
                                    withAnimation {
                                        startIsAM = true
                                    }
                                }
                            
                            Text("PM")
                                .foregroundColor(!startIsAM ? .white : .black)
                                .frame(width: 70, height: 45)
                                .onTapGesture {
                                    withAnimation {
                                        startIsAM = false
                                    }
                                }
                        }
                    }
                }
            }
            
            HStack {
                Text("End Time")
                    .font(.headline)
                Spacer()
                
                HStack {
                    Text("10:00")
                        .font(.system(size: 20))
                        .padding(4)
                        .frame(width: 70, height: 41)
                        .background(Color.lemon)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    ZStack(alignment: endIsAM ? .leading : .trailing) {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: 70, height: 45)
                            Color.clear.frame(width: 70, height: 45)
                        }
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lav)
                            .frame(width: 65, height: 40)
                            .padding(3)
                            .animation(.easeInOut(duration: 0.3), value: endIsAM)
                        HStack(spacing: 0) {
                            Text("AM")
                                .foregroundColor(endIsAM ? .white : .black)
                                .frame(width: 70, height: 45)
                                .onTapGesture {
                                    withAnimation {
                                        endIsAM = true
                                    }
                                }
                            
                            Text("PM")
                                .foregroundColor(!endIsAM ? .white : .black)
                                .frame(width: 70, height: 45)
                                .onTapGesture {
                                    withAnimation {
                                        endIsAM = false
                                    }
                                }
                        }
                    }
                }
            }
            
            
            HStack {
                Text("All Day")
                    .font(.headline)
                Spacer()
                Toggle("", isOn: $isAllDay)
                    .labelsHidden()
            }
            
            Image("line-divider")
                .resizable()
                .frame(width: 360, height: 1)
            
            Text("Mode")
                .font(.headline)
            
            HStack {
                ModeButton(title: "Regular", isSelected: selectedMode == "Regular") {
                    selectedMode = "Regular"
                }
                ModeButton(title: "Intentional", isSelected: selectedMode == "Intentional") {
                    selectedMode = "Intentional"
                }
                ModeButton(title: "Strict", isSelected: selectedMode == "Strict") {
                    selectedMode = "Strict"
                }
            }
            
            HStack {
                Text("Remind Me Every:")
                    .font(.headline)
                Spacer()
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lemon)
                            .frame(width: 40, height: 30)
                        Text("0")
                            .foregroundColor(.white)
                    }
                    Text("hr")
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.lemon)
                            .frame(width: 40, height: 30)
                        Text("20")
                            .foregroundColor(.white)
                    }
                    Text("min")
                }
            }
            
            
            HStack(spacing: 10) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 42, height: 42)
                        Text(day)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("SAVE")
                        .padding(12)
                        .frame(width: 80)
                        .background(Color.purple)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            
        }
        .padding(20)
        .presentationDetents([.height(500)]) // height of bottom sheet
    }
}

struct ModeButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Text(title)
            .font(.system(size: 15))
            .padding(5)
            .padding(.horizontal, 5)
            .background(isSelected ? Color.lemon : Color.gray.opacity(0.2))
            .cornerRadius(25)
            .onTapGesture {
                action()
            }
    }
}

#Preview {
    RuleSettingsView()
}
