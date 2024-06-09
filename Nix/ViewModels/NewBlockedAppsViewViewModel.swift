//
//  NewBlockedAppsViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 6/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import ManagedSettings
import FamilyControls


class NewBlockedAppsViewViewModel : ObservableObject {
    @Published var forNewAppGroup = false
    @Published var title = ""
    @Published var id = ""
    @Published var selectedData = ""
    
    @Published var showAlert = false
    @Published var alertMessage = ""

    func convertToOriginalTokensArray(selectedApps: String) -> [ApplicationToken]? {
        guard let data = selectedApps.data(using: .utf8) else {
            return nil
        }
        do {
            let originalTokensArray = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            return Array(originalTokensArray.applicationTokens)
        } catch {
            print(data)
            print("Error decoding selectedApps string:", error)
            return nil
        }
    }
    
    var canSave: Bool {
        alertMessage = ""
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
     
        if let selectData = userDefaults?.object(forKey: "selectedApps") as? Data {
                selectedData = String(decoding: selectData, as: UTF8.self)
        }
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage += "Please fill in the title field."
            return false
        }
        alertMessage = ""
        
        guard convertToOriginalTokensArray(selectedApps: selectedData)?.count ?? 0 >= 1 else {
            alertMessage += "At least one app needs to be selected."
            return false
        }
        alertMessage = ""

        guard convertToOriginalTokensArray(selectedApps: selectedData)?.count ?? 0 <= 50 else {
            alertMessage += "Please select less than 50 apps."
            return false
        }
        alertMessage = ""
        
        return true
    }
    func save() {
        guard canSave else {
            return
        }
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()

       
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

