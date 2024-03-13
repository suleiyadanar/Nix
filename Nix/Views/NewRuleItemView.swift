//
//  NewRuleItemView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/28/24.
//

import SwiftUI
import DeviceActivity


struct NewRuleItemView: View {
    @StateObject var viewModel = NewRuleItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    @State private var errorMessage: String = ""

    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    
    let currentDate = Date()
    
    var body: some View {
        Form {
            Text("New Rule")
            VStack {
                TextField("Title", text: $viewModel.title)
                                    .textFieldStyle(DefaultTextFieldStyle())
                DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
                
                DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
               
            
                    ScrollView {
                        HStack {
                            ForEach(0..<daysOfWeek.count, id: \.self) { index in
                                Text(self.daysOfWeek[index])
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
                
                TLButton(text: "Save", background: .pink) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    }
                    else{
                        viewModel.showAlert=true
                    }
                   
                }.alert(isPresented: $viewModel.showAlert){
                    Alert(title: Text("Error"), message: Text("Please fill in all fields and select end time that is after the start time."))
                }
            }.padding()
        }
    }
}



#Preview {
    NewRuleItemView(newItemPresented: Binding(get:{
        return true
    }, set: {_ in
    }))
}
