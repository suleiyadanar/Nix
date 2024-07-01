import SwiftUI
import FamilyControls
import FirebaseFirestoreSwift

struct BlockedAppsView: View {
    @StateObject var viewModel: BlockedAppsViewViewModel
    @State private var userId: String
    @State private var selectedItem: AppGroup?
    @State private var selection = 0
    
    @Binding var item: RuleItem?
    @ObservedObject var model = BlockedAppsModel()

    @Binding var selectionType: String
    @Binding var selectedData: String
    @Binding var showingAppGroup: Bool
    
    @FirestoreQuery var appGroups: [AppGroup]
    
    init(userId: String, selectionType: Binding<String>, selectedData: Binding<String>, showingAppGroup: Binding<Bool>, item: Binding<RuleItem?>) {
        self._appGroups = FirestoreQuery(collectionPath: "users/\(userId)/appGroups")
        self._viewModel = StateObject(wrappedValue: BlockedAppsViewViewModel(userId: userId))
        self.userId = userId
        self._selectionType = selectionType
        self._selectedData = selectedData
        self._showingAppGroup = showingAppGroup
        self._item = item
    }
    
    func savedSelection() -> FamilyActivitySelection? {
        guard let selectedData = item?.selectedData,
              let data = selectedData.data(using: .utf8) else {
            return nil
        }
        
        do {
            let selection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            print("selection found")
            return selection
        } catch {
            print("Failed to decode FamilyActivitySelection: \(error)")
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(selectionType)
                Text(item?.title ?? "No Title")
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
                    
                    List {
                        ForEach(appGroups, id: \.id) { appGroup in
                            HStack {
                                Text(appGroup.title)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(selectionType == appGroup.title ? .blue : .clear))
                                    .frame(maxWidth: .infinity)
                            )
                            .onTapGesture {
                                selectionType = appGroup.title
                                selectedItem = appGroup
                                selectedData = appGroup.selectedData
                                item?.selectedData = appGroup.selectedData
                            }
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.delete(id: appGroup.id)
                                }
                                .tint(.red)
                            }
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
                    
                    TLButton(text: "Save", background: .pink) {
                        showingAppGroup = false
                    }
                } else if selection == 1 {
                    FamilyActivityPicker(selection: Binding(
                        get: { savedSelection() ?? model.activitySelection },
                        set: { newValue in
                            if let jsonData = try? JSONEncoder().encode(newValue),
                               let jsonString = String(data: jsonData, encoding: .utf8) {
                                item?.selectedData = jsonString
                                selectedData = jsonString
                            }
                            model.activitySelection = newValue
                        }
                    ))
                    TLButton(text: "Save", background: .pink) {
                        showingAppGroup = false
                        selectionType = "Custom App"
                    }
                }
            }
            .navigationTitle("Blocked Apps")
        }
    }
}
