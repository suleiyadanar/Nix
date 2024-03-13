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
import Foundation


class NewRuleItemViewViewModel : ObservableObject {
    @Published var title = ""
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var selectedDays = Set<Int>()
    @Published var showAlert = false
    
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
        
        // Create model
        let newId = UUID().uuidString
        let newRule = RuleItem(
            id:newId,
            title: title,
            startTime: startTime.timeIntervalSince1970,
            endTime: endTime.timeIntervalSince1970,
            selectedDays: Array(selectedDays)
        )
        // Save model
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("rules")
            .document(newId)
            .setData(newRule.asDictionary())
    }
}
