//
//  LoginView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
//    let layoutProperties: LayoutProperties

    var body: some View {
        VStack {
            // Header
            LoginSignUpHeaderView(title: "Welcome back!", subtitle:"Get back in control!")
           
            // Login Form
            VStack {
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
                
                
                TLButton(text: "Login", background: Color.black){
                    viewModel.login()
                }
                if !viewModel.errorMessage.isEmpty{
                    Text(viewModel.errorMessage).foregroundColor(.red)
                }
                HStack{
                    Text("Don't have an account?")
                    NavigationLink("Sign up", destination: RegisterView())
                }
                
            }.padding(.top, 50)
            Spacer().frame(height:100)
            
            // Footer
            Image("login-wave").padding(0).edgesIgnoringSafeArea(.bottom)
                      
        }
    }
}

#Preview {
//    LoginView(layoutProperties: getPreviewLayoutProperties(height: 852, width: 393))
    LoginView()
}
