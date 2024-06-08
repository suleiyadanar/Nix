import SwiftUI
import FirebaseFirestoreSwift

struct BlockedAppsView: View {
    @StateObject var viewModel: BlockedAppsViewViewModel
    @State private var userId: String
    @State private var selectedItem: AppGroup?
    @State private var selection = 0
    @FirestoreQuery var appGroups: [AppGroup]
    
    init(userId: String) {
        self._appGroups = FirestoreQuery(collectionPath: "users/\(userId)/appGroups")
        self._viewModel = StateObject(wrappedValue: BlockedAppsViewViewModel(userId: userId))
        self.userId = userId
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selection, label: Text("Picker")) {
                    Text("App Groups").tag(0)
                    Text("Choose Apps").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selection == 0 {
                    NavigationLink(destination: NewBlockedAppsView(
                        newItemPresented: .constant(false),
                        forNewAppGroup: .constant(true)
                    )) {
                        Text("Add New")
                    }
                    
                    List(appGroups) { appGroup in
                        Text(appGroup.title)
                            .swipeActions {
                                Button("Edit") {
                                    selectedItem = appGroup
                                }
                                .tint(.blue)
                                
                                Button("Delete") {
                                    viewModel.delete(id: appGroup.id)
                                }
                                .tint(.red)
                            }
                    }
                    .sheet(item: $selectedItem) { item in
                        NavigationView {
                            NewBlockedAppsView(
                                newItemPresented: .constant(false),
                                forNewAppGroup: .constant(false),
                                appGroup: item
                            )
                        }
                    }
                    
                    TLButton(text: "Save", background: .pink) {}
                } else if selection == 1 {
                    Text("Choose Apps")
                }
            }
            .navigationTitle("Blocked Apps")
        }
    }
}
