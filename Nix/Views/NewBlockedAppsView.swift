import SwiftUI
import FamilyControls

struct NewBlockedAppsView: View {
    @StateObject var viewModel = NewBlockedAppsViewViewModel()
    @State private var pickerIsPresented = false
    @ObservedObject var model = BlockedAppsModel()
    @Binding var newItemPresented: Bool
    @Binding var forNewAppGroup: Bool
    @State var appGroup: AppGroup?
    
    @Environment(\.presentationMode) var presentationMode
    
    func savedSelection() -> FamilyActivitySelection? {
        guard let selectedData = appGroup?.selectedData,
              let data = selectedData.data(using: .utf8) else {
            return nil
        }
        
        do {
            let selection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            print("got here saved selection")
            return selection
        } catch {
            print("Failed to decode FamilyActivitySelection: \(error)")
            return nil
        }
    }
    
    var body: some View {
        VStack {
            TextField("Title", text: $viewModel.title)
                .textFieldStyle(DefaultTextFieldStyle())
                .onAppear {
                    viewModel.id = appGroup?.id ?? ""
                    viewModel.title = appGroup?.title ?? ""
                }
            
            FamilyActivityPicker(selection: Binding(
                get: { savedSelection() ?? model.activitySelection },
                set: { newValue in
                    if let jsonData = try? JSONEncoder().encode(newValue),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        appGroup?.selectedData = jsonString
                        viewModel.selectedData = jsonString
                        print(jsonString)
                    }
                    model.activitySelection = newValue
                }
            ))
            
            TLButton(text: "Save", background: .pink) {
                if viewModel.canSave {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss() // Go back to the previous view
                }else{
                    viewModel.showAlert = true
                }
            } .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage))
            }
        }
        .navigationTitle(forNewAppGroup ? "New App Group" : "Edit App Group")
        .navigationBarTitleDisplayMode(.inline)
    }
}
