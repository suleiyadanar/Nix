//
//  RegisterView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()

    var body: some View {
        VStack {
            // Header
            LoginSignUpHeaderView(title: "Join Us!", subtitle:"Get into your flow!")
            
            // Login Form
            VStack {
                VStack{
                    TextField("First Name", text: $viewModel.firstName)
                        .padding(.horizontal,20)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                    TextField("Last Name", text: $viewModel.lastName)
                        .padding(.horizontal,20)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                    TextField("Email", text: $viewModel.email)
                        .padding(.horizontal,20)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                        .padding(.horizontal,20)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                }
               
                TLButton(text: "Sign Up", background: Color.black){
                    viewModel.register()
                }
                HStack{
                    Text("Already a member?")
                    NavigationLink("Login", destination: LoginView())
                }
                
            }.padding(.top, 50)
            Spacer().frame(height:50)
            
            // Create Account
            Image("login-wave").padding(0).edgesIgnoringSafeArea(.bottom)
                      
        }
    }
}

#Preview {
//    RegisterView(layoutProperties: getPreviewLayoutProperties(height: 852, width: 393))
    RegisterView()
}
