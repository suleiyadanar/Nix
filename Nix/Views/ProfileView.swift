//
//  ProfileView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 3/1/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                }else {
                    Text("Loading Profile...")
                }
                
            }.navigationTitle("Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        // Avatar
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color.blue)
            .frame(width: 125, height:125)
        // Info: Name, Email, Member since
        VStack(alignment: .leading) {
            HStack {
                Text(user.firstName)
                Text(user.email)
                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
            }
        }
        Button("Log Out"){
            viewModel.logOut()
        }
        .tint(.red)
        .padding()
    }
}

#Preview {
    ProfileView()
}
