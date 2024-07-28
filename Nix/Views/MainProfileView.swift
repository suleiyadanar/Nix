//
//  MainProfileView.swift
//  Nix
//
//  Created by Grace Yang on 7/25/24.
//

import SwiftUI

struct MainProfileView: View {
    var body: some View {
        ScrollView {
            
            VStack {
                
                HStack {
                    Spacer()
                    Image("settings-icon")
                }
                .padding(.trailing, 15)
                .padding(.top, 30)
                
                HStack {
                    Spacer()
                    VStack {
                        Image("profile-icon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 65, height: 65)
                            .overlay(
                                Circle().stroke(Color.sky, lineWidth: 4)
                            )
                        Text("Olive")
                            .font(.system(size: 20))
                            .fontWeight(.light)
                    }
                    Spacer()
                }
                
                
                HStack {
                    
                    Spacer()
                    
                    HStack {
                        Image("points-icon")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("135 pts")
                            .font(.system(size: 15))
                    }
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill((Color.lightGray.opacity(0.7)))
                    )
                    
                    HStack {
                        Image("days-icon")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("62 days")
                            .font(.system(size: 15))
                    }
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill((Color.lightGray.opacity(0.7)))
                    )
                    
                    Spacer()
                    
                }
                .padding(.bottom, 15)
                
                VStack {
                    
                    HStack {
                        
                        VStack {
                            Text("135 hours")
                                .foregroundStyle(Color.white)
                            HStack {
                                Image("saved-icon")
                                Text("Saved")
                                    .font(.system(size:15))
                            }
                        }
                        .frame(width: 100, height: 65)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.mango)
                        )
                        
                        Image("profilepage-divider")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 2, height: 40)
                        
                        VStack {
                            Text("45 days")
                                .foregroundStyle(Color.white)
                            HStack {
                                Image("streak-icon")
                                Text("Streak")
                                    .font(.system(size:15))
                            }
                        }
                        .frame(width: 100, height: 65)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.lav)
                        )
                        
                    }
                    
                    Image("profilepage-horiz-divider")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 2)
                    
                    HStack {
                        
                        VStack {
                            Text("15")
                                .foregroundStyle(Color.white)
                            HStack {
                                Image("rules-icon")
                                Text("Rules")
                                    .font(.system(size:15))
                            }
                        }
                        .frame(width: 100, height: 65)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue)
                        )
                        
                        Image("profilepage-divider")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 2, height: 40)
                        
                        
                        VStack {
                            Text("53")
                                .foregroundStyle(Color.white)
                            HStack {
                                Image("pomodoros-icon")
                                Text("Pomodoros")
                                    .font(.system(size:15))
                            }
                        }
                        .frame(width: 100, height: 65)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.sky)
                        )
                        
                    }
                }
                
                
                Text("Why you started?")
                    .font(.system(size: 20))
                    .padding(.top, 15)
                
                
                GoalRow(goal: "Goal #1", text: "Spend more time with friends")
                    .padding(.bottom, 10)
                
                GoalRow(goal: "Goal #2", text: "Work on my career development")
                    .padding(.bottom, 10)
                
                Spacer(minLength: 20)
                
                HStack {
                    Text("Map")
                        .font(.system(size: 20))
                        .padding(.leading, 15)
                    Spacer()
                }
                .padding(.bottom, 30)
                
                HStack {
                    Text("Progress")
                        .font(.system(size: 20))
                        .padding(.leading, 15)
                    Spacer()
                }
                
                Spacer()
                
            }
        }
        .background(Color.babyBlue.opacity(0.5))

    }
}

struct GoalRow: View {
    var goal: String
    var text: String
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 320, height: 65)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 5, y: 5)
                                
                
                VStack (alignment: .leading){
                    Text(goal)
                        .padding(.leading, 20)
                        .padding(.bottom, 5)
                    Text(text)
                        .padding(.leading, 20)
                        .fontWeight(.light)
                    
                }
                .padding(7)
                
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 10))
                    .fill(Color.sky)
                    .frame(width: 10, height: 65)
            }
        }
    }
}


#Preview {
    MainProfileView()
}
