//
//  NewRuleItemViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import FirebaseAuth
import FirebaseFirestore
import DeviceActivity
import FamilyControls
import ManagedSettings
import Foundation


class NewRuleItemViewViewModel : ObservableObject {
    @Published var id = ""
    @Published var title = ""
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var selectedDays = Set<Int>()
//    @Published var selectedApps = Set<ApplicationToken>()
    @Published var showAlert = false
    
    var selectedApps = String()
    var selectedData = String()
    init(){}
    
    var canSave : Bool{
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard startTime < endTime else {
            return false
        }
        
        return true
    }
    /// This is documentation summary for save()
    ///
    /// This is discussion
    /// ```swift
    /// @StateObject var viewModel = NewRuleItemViewViewModel()

    ///
    /// var body: some View {
    ///     Image(iceSloth)
    ///         .resizable()
    ///         .aspectRatio(contentMode: .fit)
    ///     Text(iceSloth.name)
    /// }
    /// ```
    func save(){
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else{
            return
        }
        
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
     
            if let appData = userDefaults?.object(forKey: "applications") as? Data {
                selectedApps = String(decoding: appData, as: UTF8.self)
                }
            
            if let selectData = userDefaults?.object(forKey: "selectedApps") as? Data {
                selectedData = String(decoding: selectData, as: UTF8.self)
                }
         
        
        let db = Firestore.firestore()
        
        if self.id != "" {
            // Update model
            db.collection("users")
                .document(uId)
                .collection("rules")
                .document(id)
                .updateData(["title":title, "startTime":startTime.timeIntervalSince1970, "endTime":endTime.timeIntervalSince1970,
                    "selectedDays": Array(selectedDays),
                    "selectedApps": selectedApps,
                    "selectedData": selectedData])
            print(selectedApps)
        }else {
            // Create model
            let newId = UUID().uuidString
            let newRule = RuleItem(
                id:newId,
                title: title,
                startTime: startTime.timeIntervalSince1970,
                endTime: endTime.timeIntervalSince1970,
                selectedDays: Array(selectedDays),
                selectedApps: selectedApps,
                selectedData: selectedData
            )
            print(selectedApps)

            // Save model
            db.collection("users")
                .document(uId)
                .collection("rules")
                .document(newId)
                .setData(newRule.asDictionary())
        }
        
       
    }
}
