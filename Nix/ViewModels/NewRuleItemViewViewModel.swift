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
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @Published var showingAppGroup = false
    
    var selectedApps = String()
    var selectedData = String()
    var selectionType = String()
    
    func convertToOriginalTokensArray(selectedApps: String) -> [ApplicationToken]? {
        guard let data = selectedApps.data(using: .utf8) else {
            return nil
        }
        do {
            let originalTokensArray = try JSONDecoder().decode([ApplicationToken].self, from: data)
            return originalTokensArray
        } catch {
            print("Error decoding selectedApps string:", error)
            return nil
        }
    }
    
    init(){}
    
    var canSave : Bool{
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
     
            if let appData = userDefaults?.object(forKey: "applications") as? Data {
                selectedApps = String(decoding: appData, as: UTF8.self)
                }
            
            if let selectData = userDefaults?.object(forKey: "selectedApps") as? Data {
                selectedData = String(decoding: selectData, as: UTF8.self)
                }
        
        alertMessage = ""
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage += "Please fill in the title field."
            return false
        }
        alertMessage = ""
        let timeInterval = endTime.timeIntervalSince(startTime)
        let minimumInterval: TimeInterval = 15 * 60 // 15 minutes in seconds
        
        print(timeInterval)
        print(minimumInterval)
        guard timeInterval >= minimumInterval else {
            print("Got here")
            alertMessage += "The session needs to be at least 15 minutes long."
            return false
        }
        alertMessage = ""
        print(convertToOriginalTokensArray(selectedApps: selectedApps) ?? "nah")

        guard convertToOriginalTokensArray(selectedApps: selectedApps)?.count ?? 0 >= 1 else {
            alertMessage += "At least one app needs to be selected."
            return false
        }
        alertMessage = ""

        guard convertToOriginalTokensArray(selectedApps: selectedApps)?.count ?? 0 <= 50 else {
            alertMessage += "Please select less than 50 apps."
            return false
        }
        alertMessage = ""

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

       
        let db = Firestore.firestore()
        
        if self.id != "" {
            // Update model
            print("updating")
            db.collection("users")
                .document(uId)
                .collection("rules")
                .document(id)
                .updateData(["title":title, "startTime":startTime.timeIntervalSince1970, "endTime":endTime.timeIntervalSince1970,
                             "selectedDays": Array(selectedDays).sorted(),
                    "selectedApps": selectedApps,
                    "selectedData": selectedData,
                             "selectionType": selectionType
                            ])
        }else {
            // Create model
            print("creating")
            let newId = UUID().uuidString
            let newRule = RuleItem(
                id:newId,
                title: title,
                startTime: startTime.timeIntervalSince1970,
                endTime: endTime.timeIntervalSince1970,
                selectedDays: Array(selectedDays).sorted(),
                selectedApps: selectedApps,
                selectedData: selectedData,
                selectionType: selectionType
            )

            // Save model
            db.collection("users")
                .document(uId)
                .collection("rules")
                .document(newId)
                .setData(newRule.asDictionary())
        }
        
       
    }
}
