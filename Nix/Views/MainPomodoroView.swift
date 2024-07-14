//
//  MainPomodoroView.swift
//  Nix
//
//  Created by Grace Yang on 7/5/24.
//

import SwiftUI

struct MainPomodoroView: View {
    var props: Properties

    @StateObject var viewModel = PomodoroViewViewModel()
    var userId: String
   
    var body: some View {
        ZStack {
            VStack { // background
                Spacer()
                Image("pomodoro-background")
                    .padding(.bottom, 85)
            }
            VStack {
                HStack (spacing: 15 ){
                    Image("pomodoro-bubble-fill")
                    Image("pomodoro-bubble-fill")
                    Image("pomodoro-bubble")
                    Image("pomodoro-bubble")
                }
                .padding(.top, 50)
                
                Text("SESSION")
                    .font(.headline)
                    .padding(.top, 10)
                           
                Text("25:00")
                    .font(.system(size: 70, weight: .bold))
                    .offset(y:-5)
                
                Image("baby-seal-nix")
                    .offset(y: -40)
                
                HStack {
                    Spacer()
                    Image("pomodoro-options-button")
                        .padding(5)
                    Image("pomodoro-pause-button")
                        .padding(5)
                    Image("pomodoro-skip-button")
                        .padding(5)
                    Spacer()
                }
                .offset(y: -40)
                
                HStack {
                    Spacer()
                    HStack {
                        Text("Select Apps")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.mauve)
                    }
                    .padding(.horizontal, 13)
                    .padding(.vertical, 5)
                    .background(Color.lemon)
                    .cornerRadius(20)
                    Spacer()
                }
                .offset(y: -40)
                
                HStack {
                    Spacer()
                    Text("Apps Frozen: 23")
                        .font(.system(size: 15))
                    Spacer()
                }
                .offset(y: -40)

            }
        }
    }
}

