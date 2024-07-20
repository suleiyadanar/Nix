//
//  ProfileView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 3/1/24.
//

import SwiftUI

struct ProfileView: View {
    var props: Properties

    @EnvironmentObject var userSettings: UserSettings

    @StateObject var viewModel = ProfileViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State var settingsView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                    
                }else {
                    Button("Log Out"){
                        viewModel.logOut()

                    }
                    Text("Loading Profile...")
                }
                
            }//.navigationTitle("Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }

    
    @ViewBuilder
    func profile(user: User) -> some View {
        ScrollView {
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.settingsView = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 23.5, height: 23)
                            .padding(.top, 11)
                            .padding(.trailing, 17)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                }
                
                HStack {
                    Image(systemName: "person.circle") // Avatar
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.indigo)
                        .frame(width: 80, height: 80)
                        .padding(.leading, 10)
                        .padding(.trailing, 15)
                    VStack {
                        HStack {
                            Text(user.firstName).fontWeight(.heavy)
                                .font(.system(size: 30))
                            Spacer()
                        }
                        HStack {
                            Text(user.email)
                            Spacer()
                        }
                        
                    }
                }
                
                Spacer(minLength:15)
                
                VStack {
                    VStack {
                        HStack {
                            Text("You have been a Nix Member since: ")
                                .font(.system(size: 10))
                                .foregroundStyle(Color.black)
                        }
                        HStack {
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.black)
                        }
                    }
                    
                    .padding(10)
                    .background(Rectangle().fill(Color.lavender).shadow(radius: 3).frame(width: 500))
                    
                    Spacer (minLength: 15)
                    
                    HStack {
                        Text("progress: ").fontWeight(.heavy)
                        Spacer()
                    }
                    
                      
                    ZStack {
                        Rectangle() // add screentime progress report
                            .foregroundStyle(Color.indigo)
                            .frame(width: 350, height: 250)
                            .cornerRadius(35)
                            .padding(.bottom, 20)
                        VStack {
                            HStack {
                                Spacer()
                                Text("TOTAL HOURS SAVED FROM REDUCING SCREENTIME: _______")
                                    .padding()
                                    .foregroundStyle(Color.white)
                                Spacer()
                            }
                            HStack {
                                VStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("GOAL 1:")
                                    Text("_______")
                                    Text("_______")
                                    Text("_______")
                                }
                                    .padding()
                                    .background(Color.lavender)
                                    .cornerRadius(35)
                                VStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("GOAL 2:")
                                    Text("_______")
                                    Text("_______")
                                    Text("_______")
                                }
                                    .padding()
                                    .background(Color.lavender)
                                    .cornerRadius(35)
                                VStack {
                                    Image(systemName: "checkmark.circle")
                                    Text("GOAL 3:")
                                    Text("_______")
                                    Text("_______")
                                    Text("_______")
                                }
                                    .padding()
                                    .background(Color.lavender)
                                    .cornerRadius(35)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    
                    HStack {
                        Text("journey map: ").fontWeight(.heavy)
                        Spacer()
                    }
                    VStack {
                        Rectangle() // journey map!
                            .foregroundStyle(Color.lavender)
                            .frame(width: 350, height: 100)
                            .cornerRadius(35)
                            .padding(.bottom, 20)
                        
                    }
                    
                    HStack {
                        Text("statistics: ").fontWeight(.heavy)
                        Spacer()
                    }
                    ZStack {
                        Rectangle() // add screentime statistics
                            .foregroundStyle(Color.lavender)
                            .frame(width: 350, height: 300)
                            .padding(.bottom, 20)
                        Rectangle() // add screentime statistics
                            .foregroundStyle(Color.indigo)
                            .frame(width: 300, height: 250)
                            .padding(.bottom, 20)
                        Text("Insert cool-looking graph for screentime statistics!!!")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.white)
                            
                    }
                    
                    Button("Log Out"){
                        userSettings.ready = false
                        viewModel.logOut()

                    }
                    .tint(.red)
                    .padding()

                    
                }

            }
            .padding(.leading, 50)
            .padding(.trailing, 50)
            
        }
        .sheet(isPresented: $settingsView) {
            SettingsView()
        }
    }
    
}


//#Preview {
//    ProfileView()
//}
