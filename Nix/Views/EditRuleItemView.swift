//
//  EditRuleItemView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 3/14/24.
//

import SwiftUI
import DeviceActivity
import FamilyControls

func convertToOriginalSelection(selection: String) -> FamilyActivitySelection? {
    guard let data = selection.data(using: .utf8) else {
        return nil
    }
    do {
        let originalSelection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        return originalSelection
    } catch {
        print("Error decoding originalSelection string:", error)
        return nil
    }
}

struct EditRuleItemView: View {
    @StateObject var viewModel = EditRuleItemViewViewModel()
    @State private var pickerIsPresented = false

    @State var item : RuleItem
    
    @Binding var newItemPresented: Bool
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {

        Form {
            Text("New Rule")
            VStack {
                TextField("Title", text: $viewModel.title)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .onAppear {
                                        viewModel.id = item.id
                                        viewModel.title = item.title
                                            }
                                            
                DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
                    .onAppear {
                        viewModel.startTime = Date(timeIntervalSince1970: item.startTime)
                    }
                
                DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
                    .onAppear {
                        viewModel.endTime = Date(timeIntervalSince1970: item.endTime)
                    }
            
                    ScrollView {
                        HStack {
                            ForEach(0..<daysOfWeek.count, id: \.self) { index in
                                Text(self.daysOfWeek[index])
                                    .onAppear{
                                        self.viewModel.selectedDays =  Set(item.selectedDays)
                                    }
                                    .frame(width:40, height:40)
                                    .background(self.viewModel.selectedDays.contains(index) ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                                    .padding(3)
                                    .onTapGesture {
                                        if self.viewModel.selectedDays.contains(index) {
                                            self.viewModel.selectedDays.remove(index)
                                        } else {
                                            self.viewModel.selectedDays.insert(index)
                                        }
                                    }
                            }
                        }
                    .frame(maxWidth: .infinity)
                }
                Button {
                    pickerIsPresented = true
                } label: {
                    Text("Select Apps")
                }
                .familyActivityPicker(
                    isPresented: $pickerIsPresented,
                    selection: Binding(
                        get: {
                            if let originalSelection = convertToOriginalSelection(selection: item.selectedData) {
                                return originalSelection
                            } else {
                                // If conversion fails, return nil
                                return FamilyActivitySelection()
                            }
                        }
                          ,
                        set: { newValue in
                            // Set does not need to be implemented
                        }
                    )
                )
                TLButton(text: "Save", background: .pink) {
                   
                    if viewModel.canSave {
                        viewModel.update()
                        newItemPresented = false
                    }
                    else {
                        viewModel.showAlert=true
                    }
                   
                }.alert(isPresented: $viewModel.showAlert){
                    Alert(title: Text("Error"), message: Text("Please fill in all fields and select end time that is after the start time."))
                }
            }.padding()
        }
    }
}

//#Preview {
//    EditRuleItemView()
//}
