//
//  NewBlockedAppsView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 6/5/24.
//

import SwiftUI
import FamilyControls

struct NewBlockedAppsView: View {
    @StateObject var viewModel = NewBlockedAppsViewViewModel()
    @State private var pickerIsPresented = false
    @ObservedObject var model = BlockedAppsModel()
    @Binding var newItemPresented: Bool
    @Binding var forNewAppGroup: Bool

    @State var appGroup : AppGroup?
    @State var ruleId : String
    

    func savedSelection(selectionKey: String) -> FamilyActivitySelection? {
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")!
        guard let data = userDefaults.object(forKey: selectionKey) as? Data else {
                return nil
        }
        return try? JSONDecoder().decode(
                FamilyActivitySelection.self,
                from: data
            )
        }
    
    var body: some View {
        VStack{
            if forNewAppGroup {
                TextField("Title", text: $viewModel.keyName)
                    .textFieldStyle(DefaultTextFieldStyle())
            }
            FamilyActivityPicker(selection: Binding(
                get: {savedSelection(selectionKey: appGroup?.keyName ?? ruleId) ?? model.activitySelection},
                set: { newValue in
                    model.appGroupName = viewModel.keyName
                    model.activitySelection = newValue
                }
            ))
            TLButton(text: "Save", background: .pink) {
                // add the name to database
                viewModel.save()
                newItemPresented=false
                if appGroup == nil {
                    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")!
                    userDefaults.removeObject(forKey: ruleId)
                }
                
            }
        }
    }
}

