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
    @Published var fromDate = Date()
    @Published var toDate = Date()
    
    @Published var intentionalHours: Int = 0
    @Published var intentionalMinutes: Int = 0
    
    @Published var selectedDays = Set<Int>()
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @Published var showingAppGroup = false
    
    @Published var mode: RuleMode = .regular
    @Published var unlock: UnlockMethod = .math
    @Published var delay: DelayTime = .none
    @Published var timeOutLength: TimeoutLength = .one
    @Published var timeOutAllowed: Int = Int.max
    
    @Published var color : String = ""
    
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
    enum RuleMode: String, Codable {
        case regular = "Regular"
        case intentional = "Intentional"
        case strict = "Strict"
    }
    enum UnlockMethod: String, Codable {
        case math = "Math Problem"
        case entry = "Entry Prompt"
    }
    enum DelayTime: Int, Codable {
        case none = 0
        case two = 2
        case five = 5
        case fifteen = 15
        case thirty = 30
        case hour = 60
        case three_hour = 180
    }
    enum TimeoutLength: Int, Codable {
        case one = 1
        case five = 5
        case fifteen = 15
        case thirty = 30
        case hour = 60
    }
    
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
        print("count id", self.id.count)
        if self.id != "" && self.id.count > 1 {
            // Update model
            print("updating")
            db.collection("users")
                .document(uId)
                .collection("rules")
                .document(id)
                .updateData(["title":title, "startTime":startTime.timeIntervalSince1970, "endTime":endTime.timeIntervalSince1970, "fromDate": fromDate.timeIntervalSince1970,
                             "toDate": toDate.timeIntervalSince1970,
                             "selectedDays": Array(selectedDays).sorted(),
                    "selectedApps": selectedApps,
                    "selectedData": selectedData,
                             "selectionType": selectionType,
                             "mode": mode.rawValue,
                             "unlock": unlock.rawValue,
                             "delay": delay.rawValue,
                             "timeOutLength": timeOutLength.rawValue,
                             "timeOutAllowed": timeOutAllowed,
                             "intentionalMinutes": intentionalMinutes,
                             "intentionalHours": intentionalHours,
                             "color": color
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
                fromDate: fromDate.timeIntervalSince1970,
                toDate: toDate.timeIntervalSince1970,
                selectedDays: Array(selectedDays).sorted(),
                selectedApps: selectedApps,
                selectedData: selectedData,
                selectionType: selectionType,
                mode: mode.rawValue,
                unlock: unlock.rawValue,
                delay: delay.rawValue,
                timeOutLength: timeOutLength.rawValue,
                timeOutAllowed: timeOutAllowed,
                intentionalMinutes: intentionalMinutes,
                intentionalHours: intentionalHours,
                color: color
            )

            // Save model
            db.collection("users")
                .document(uId)
                .collection("rules")
                .document(newId)
                .setData(newRule.asDictionary())
            
//            addNotification()
                
        }
        
    }
    
    

    
    


}
