//
//  JourneyMapView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/15/24.
//

import SwiftUI

struct JourneyMapView: View {
    var days: Int
    var unlockedDays: Int
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 40) {
                ForEach(0..<days, id: \.self) { index in
                    let isUnlocked = index < unlockedDays
                    let fillColor = isUnlocked ? Color.babyBlue : Color.white
                    let isToday = (index + 1) == unlockedDays
                    
                    Group {
                        
                        MapNode(title: "Day \(index + 1)", color: .clear)
                            .frame(width: 150, height: 150)
                            .overlay {
                                ZStack {
                                    Circle()
                                        .stroke(Color.sky, lineWidth: 10)
                                        .fill(fillColor)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 10)
                                                .blur(radius: 5)
                                                .opacity(isToday ? 1 : 0)
                                        )
                                    Text("Day \(index + 1)")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.horizontal, 150)
                            .padding(.vertical, 40)
                            .scrollTransition { effect, phase in
                                effect
                                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                    .offset(x: offset(for: phase))
                            }
                        if (index + 1) % 3 == 0 {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.2))
                                .frame(maxWidth: .infinity, maxHeight: 100) // Adjust height as needed
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            Text("Week \((index+1)/3)")
                        }
                    }
                }
            }
            .background(
                Image("bgMap")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .background(Color.sky)
        .ignoresSafeArea()
    }
    
    func offset(for phase: ScrollTransitionPhase) -> CGFloat {
        switch phase {
        case .topLeading:
            return 200
        case .identity:
            return 0
        case .bottomTrailing:
            return -200
        }
    }
}

struct MapNode: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .foregroundColor(.black)
    }
}

struct JourneyMapView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyMapView(days: 3, unlockedDays: 1)
    }
}
