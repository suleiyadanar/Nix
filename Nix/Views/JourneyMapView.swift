//
//  JourneyMapView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/15/24.
//

import SwiftUI

struct JourneyMapView: View {
    var body: some View {
            ScrollView {
                VStack(spacing: 40) {
                    ForEach(Array(MapNode.preview.enumerated()), id: \.offset) { index, item in
                        item.color
                            .frame(width: 150, height: 150)
                            .overlay{
                                ZStack{
                                    Circle()
                                        .stroke(Color.sky, lineWidth: 10)
                                    .fill(Color.white)
                                    Text(item.title)
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
                    
                    }
                }
                .background(
                    Image("bgMap")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
            }.background(Color.sky)
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

struct MapNode: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    
    static let preview: [MapNode] = [
        MapNode(title: "Row 1", color: .clear),
        MapNode(title: "Row 2", color: .clear),
        MapNode(title: "Row 3", color: .clear),
        MapNode(title: "Row 4", color: .clear),
        MapNode(title: "Row 5", color: .clear),
    ]
}

struct JourneyMapView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyMapView()
    }
}
