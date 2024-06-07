//
//  BlockedAppsView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 6/5/24.
//

import SwiftUI
import FirebaseFirestoreSwift



struct BlockedAppsView: View {
    @StateObject var viewModel: BlockedAppsViewViewModel
    
    @State private var userId : String
    
    @State private var selectedItem: AppGroup?
    
    @State private var selection = 0
    
    
    @State var ruleId: String
    @FirestoreQuery var appGroups: [AppGroup]
    
    init(userId: String, ruleId: String){
        self._appGroups = FirestoreQuery(collectionPath:"users/\(userId)/appGroups")
        self._viewModel = StateObject(
            wrappedValue: BlockedAppsViewViewModel(userId: userId))
        self.userId = userId
        self.ruleId = ruleId
    }
    
    var body: some View {
        VStack {
            Picker(selection: $selection, label: Text("Picker")) {
                Text("App Groups").tag(0)
                Text("Choose Apps").tag(1)
                // Add more segments as needed
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Show views based on selection
            if selection == 0 {
                Button (action: {
                    viewModel.showingNewAppGroupView = true
                }){
                    Text("Add New")
                }.sheet(isPresented: $viewModel.showingNewAppGroupView){
                    NewBlockedAppsView(newItemPresented: $viewModel.showingNewAppGroupView,
                                       forNewAppGroup: $viewModel.forNewAppGroup,
                                       ruleId: ruleId)
                }
                
                List(appGroups) { appGroup in
                    Button(action:{
                        selectedItem = appGroup
                        viewModel.reviewAppGroupView = true
                        
                    }) {
                        Text(appGroup.keyName)
                            .sheet(isPresented: $viewModel.reviewAppGroupView){
                                NewBlockedAppsView(newItemPresented: $viewModel.showingNewAppGroupView, forNewAppGroup: $viewModel.forNewAppGroup, ruleId:ruleId)
                            }
                        
                            .swipeActions {
                                Button("Delete"){
                                    // delete from model
                                    // connect to the app groups
                                    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")!
                                    
                                    userDefaults.removeObject(forKey: ruleId)
                                    // delete from db
                                    viewModel.delete(id:appGroup.id)
                                }
                                .tint(.red)
                            }
                    }
                    
                    
                }
                TLButton(text:"Save", background:.pink){
                    
                }
            }else if selection == 1 {
                    Text("Choose Apps")
                }
            
        }
    }
}
