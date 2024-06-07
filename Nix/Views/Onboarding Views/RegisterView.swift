//
//  RegisterView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @State private var optIn: Bool = false
    @State private var navigate: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Creating your account for you...")
                        .font(.system(size: 30))
                        .bold()
                        .padding(.leading, 15)
                    Spacer()
                }
                
                // Login Form
                VStack {
                    VStack{
                        HStack {
                            Text("Username*")
                                .foregroundStyle(Color.sky)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        }
                        TextField("Username", text: $viewModel.firstName)
                            .padding(.horizontal,20)
                            .frame(width: 250, height: 40)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .autocorrectionDisabled()
                            .padding(.bottom, 10)
                        
                        HStack {
                            Text("Password*")
                                .foregroundStyle(Color.sky)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        }
                        SecureField("Strong Password", text: $viewModel.password)
                            .padding(.horizontal,20)
                            .frame(width: 250, height: 40)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .autocorrectionDisabled()
                            .padding(.bottom, 10)
                        
                        HStack {
                            Text("Birthday*")
                                .foregroundStyle(Color.sky)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        }
                        TextField("01/01/2001", text: $viewModel.birthday)
                            .padding(.horizontal,20)
                            .frame(width: 250, height: 40)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .autocorrectionDisabled()
                            .padding(.bottom, 10)
                        
                        HStack {
                            Text("Educational Email Address*")
                                .foregroundStyle(Color.sky)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        }
                        TextField("olive@brandeis ", text: $viewModel.email)
                            .padding(.horizontal,20)
                            .frame(width: 250, height: 40)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .padding(.bottom, 10)
                        
                        HStack {
                            Text("College*")
                                .foregroundStyle(Color.sky)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        }
                        TextField("Brandeis University", text: $viewModel.college)
                            .padding(.horizontal,20)
                            .frame(width: 250, height: 40)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                        
                        HStack {
                            Text("Year*")
                                .foregroundStyle(Color.sky)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        }
                        TextField("Junior", text: $viewModel.year)
                            .padding(.horizontal,20)
                            .frame(width: 250, height: 40)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                        
                        HStack {
                            Text("Major*")
                                .foregroundStyle(Color.sky)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                        }
                        TextField("Computer Science", text: $viewModel.major)
                            .padding(.horizontal,20)
                            .frame(width: 250, height: 40)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                    }
                    
                    HStack(alignment: .top) {
                        Toggle("", isOn: $optIn)
                            .toggleStyle(CheckboxToggle())
                            .padding(.leading, 18)
                            .offset(y:-2)
                        Text("Opt in to our mailing list for FREE productivity and study tips from a community of students all over the globe.")
                            .font(.system(size: 15))
                            .foregroundColor(Color.blue)
                            .padding(.top, 4)
                            .padding(.leading, 2)
                    }
                    .padding(.bottom, 20)
                    
                    Text("By creating an account you accept our ")
                        .font(.footnote)
                        .foregroundColor(.gray) +
                    Text("Terms and Conditions")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .underline()

                    Button {
                        viewModel.register()
                        navigate = true
                    } label: {
                        ButtonView(text:"Create Account")
                    }
                    .padding(.top)
                    
                    HStack{
                        Text("Already a member?")
                        NavigationLink("Login", destination: LoginView())
                    }
                    
                }.padding(.top, 10)
                
            }
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0) // This ensures the safe area on top
        }
        .navigationDestination(isPresented: $navigate) {
            Onboarding10View()
        }
    }
}

struct CheckboxToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? Color.blue : Color.gray)
                configuration.label
            }
        }
    }
}

#Preview {
//    RegisterView(layoutProperties: getPreviewLayoutProperties(height: 852, width: 393))
    RegisterView()
}
