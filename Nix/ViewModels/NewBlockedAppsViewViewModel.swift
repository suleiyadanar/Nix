//
//  NewBlockedAppsViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 6/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class NewBlockedAppsViewViewModel : ObservableObject {
    @Published var forNewAppGroup = false
    @Published var keyName = ""
    @Published var id = ""
    
    
    func save() {
        let db = Firestore.firestore()

        if self.id != "" {
            
        }
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        
        let newId = UUID().uuidString
        let newAppGroup = AppGroup(id: newId, keyName: keyName)
        db.collection("users")
            .document(uId)
            .collection("appGroups")
            .document(newId)
            .setData(newAppGroup.asDictionary())
    }
    
}

