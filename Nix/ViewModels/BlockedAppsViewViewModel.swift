//
//  BlockedAppsViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 6/5/24.
//

import Foundation
import FirebaseFirestore

class BlockedAppsViewViewModel : ObservableObject {
    @Published var showingNewAppGroupView = false
    @Published var reviewAppGroupView = false
    @Published var forNewAppGroup = false

    @Published var id = ""
    private let userId : String

    init(userId: String){
        self.userId = userId
    }
    
   
    func delete(id:String){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("appGroups")
            .document(id)
            .delete()
    }
}
