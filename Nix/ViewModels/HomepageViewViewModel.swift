//
//  HomepageViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/19/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomepageViewViewModel: ObservableObject {
    init(){}
    
    @Published var user: User? = nil
    var greeting: String {
            let hour = Calendar.current.component(.hour, from: Date())
            switch hour {
            case 6..<12:
                return "Good Morning"
            case 12..<17:
                return "Good Afternoon"
            case 17..<22:
                return "Good Evening"
            default:
                return "Good Night"
            }
        }
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    college: data["college"] as? String ?? "",
                    year: data["year"] as? String ?? "",
                    major: data["major"] as? String ?? "",
                    opt: data["opt"] as? Bool ?? false,
                    goals: data["goals"] as? Array<String> ?? [""],
                    unProdST: data["unProdST"] as? String ?? "",
                    maxUnProdST: data["maxUnProdST"] as? Int ?? 0
                )
            }
        }
    }
}
