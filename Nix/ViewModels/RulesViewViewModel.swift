//
//  RulesViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import FirebaseFirestore
import Foundation

class RulesViewViewModel : ObservableObject {
    @Published var showingNewItemView = false
    @Published var showingEditItemView = false
    @Published var showingTemplateView = false
    private let userId : String
    
    init(userId: String){
        self.userId = userId
    }
    
    func delete(id:String){
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("rules")
            .document(id)
            .delete()
    }
}
