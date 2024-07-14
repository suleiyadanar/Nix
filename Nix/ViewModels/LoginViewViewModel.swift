//
//  LoginViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//
import FirebaseAuth
import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login(){
        guard validate() else{
            return
        }
        
        // Try log in
        Auth.auth().signIn(withEmail: email, password: password)
        print("login in done")
    }
    
    func validate() -> Bool {
        print("validating")
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter valid email."
            return false
        }
        
        return true
    }
}
