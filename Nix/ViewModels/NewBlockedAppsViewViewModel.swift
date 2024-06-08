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
    @Published var title = ""
    @Published var id = ""
    @Published var selectedData = ""
    
    
    func save() {
        let db = Firestore.firestore()

        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
     
//            if let appData = userDefaults?.object(forKey: "applications") as? Data {
//                selectedApps = String(decoding: appData, as: UTF8.self)
//                }
//            
            if let selectData = userDefaults?.object(forKey: "selectedApps") as? Data {
                selectedData = String(decoding: selectData, as: UTF8.self)
                }
        
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        print("before update", selectedData)
        print(id)
        if self.id != "" {
            print("updating")
            // Update model
            db.collection("users")
                .document(uId)
                .collection("appGroups")
                .document(id)
                .updateData(["title": title, "selectedData": selectedData])
        }else {
            print("saving new")
            let newId = UUID().uuidString
            let newAppGroup = AppGroup(id: newId, title: title, selectedData: selectedData)
            
            db.collection("users")
                .document(uId)
                .collection("appGroups")
                .document(newId)
                .setData(newAppGroup.asDictionary())
        }
    }
    
}

