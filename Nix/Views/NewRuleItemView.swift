//
//  NewRuleItemView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/28/24.
//

import SwiftUI
import DeviceActivity
import ManagedSettings
import FamilyControls

struct NewRuleItemView: View {
    @StateObject var viewModel = NewRuleItemViewViewModel()
    @State private var pickerIsPresented = false
    @ObservedObject var model = BlockedAppsModel()
    @Binding var newItemPresented: Bool

    @State var item : RuleItem?

    @State private var errorMessage: String = ""

    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let currentDate = Date()
    
    
    func savedSelection() -> FamilyActivitySelection? {
        // Check if the rule is saved
        guard let selectedData = item?.selectedData else {
            print("selectedData is nil")
            return nil
        }

        guard let data = selectedData.data(using: .utf8) else {
            print("Failed to convert selectedData to Data")
            return nil
        }
           
           do {
               let selection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
               return selection
           } catch {
               // Handle the decoding error if necessary
               print("Failed to decode FamilyActivitySelection: \(error)")
               return nil
           }
        }
    

    
    var body: some View {
        VStack {
            Text("New Rule")
            Text(String(newItemPresented))
            Text(item?.id ?? "None")
            VStack {
                
                TextField("Title", text: $viewModel.title)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .onAppear {
                                        viewModel.id = item?.id ?? ""
                                        viewModel.title = item?.title ?? ""
                                        viewModel.selectedDays = Set(item?.selectedDays ?? [])
                                    }
                

                // SELECT START TIME
                DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
                    .onAppear {
                        viewModel.startTime = Date(timeIntervalSince1970: item?.startTime ?? Date().timeIntervalSince1970)
                    }
                // SELECT END TIME
                DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
                    .onAppear {
                        viewModel.endTime = Date(timeIntervalSince1970: item?.endTime ?? Date().timeIntervalSince1970)
                    }
                Button {
                            pickerIsPresented = true
                        } label: {
                            Text("Select Apps")
                        }
                        .familyActivityPicker(
                            isPresented: $pickerIsPresented,
                            selection: Binding(
                                get: { savedSelection() ?? model.activitySelection},
                                set: { newValue in
                                    if let jsonData = try? JSONEncoder().encode(newValue),
                                                          let jsonString = String(data: jsonData, encoding: .utf8) {
                                                           item?.selectedData = jsonString
                                                       } 
                                    model.activitySelection = newValue
                            }
                            ))
                
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
                   
                    var activityName = DeviceActivityName(rawValue: "\(viewModel.title)")
                    let calendar = Calendar.current
                    var intervalStart = calendar.dateComponents([.hour, .minute], from: self.viewModel.startTime)
                    var intervalEnd = calendar.dateComponents([.hour, .minute], from: self.viewModel.endTime)
                    
//                    let warningTimeComponent = calendar.date(byAdding: .minute, value: -5, to: self.viewModel.startTime)
//                    let warningTime = calendar.dateComponents([.hour, .minute], from: warningTimeComponent ?? Date())
                    var warningTime = DateComponents()
                    warningTime.minute = 5
                
//                    print("\(warningTime.hour!):\(warningTime.minute!)")
                        let center = DeviceActivityCenter()
                        var schedule = DeviceActivitySchedule(intervalStart:intervalStart, intervalEnd: intervalEnd,repeats: false)
                    
                    
                    if (viewModel.selectedDays.count == 0) {
                        do {
                            try center.startMonitoring(activityName, during: schedule)

                            print("monitoring")
                        } catch let error {
                            print("error\(error)")
                        }
                    }else {
                        for i in 0..<viewModel.selectedDays.count{
                            activityName = DeviceActivityName(rawValue: "\(viewModel.title)" + String(i))
                            intervalStart.weekday = Array(viewModel.selectedDays)[i]+1
                            intervalEnd.weekday = Array(viewModel.selectedDays)[i]+1
                            schedule = DeviceActivitySchedule(intervalStart:intervalStart, intervalEnd: intervalEnd,repeats: true, warningTime: warningTime)
                        }
                        do {
                            try center.startMonitoring(activityName, during: schedule)

                            print("monitoring")
                        } catch let error {
                            print("error\(error)")
                        }
                    }
                  
                    
                    
                    
                    
                    
//                    for day in self.viewModel.selectedDays {
//                        let dayOfWeek = self.daysOfWeek[day]
//                        let daily = DeviceActivityName(rawValue: dayOfWeek)
//                        let schedule = DeviceActivitySchedule(intervalStart:intervalStart, intervalEnd: intervalEnd,repeats: true)
//                        do {
//                            try center.startMonitoring(.daily, during: schedule)
//
//                        }catch let error{
//                            print("error\(error)")
//                        }
//                    }

                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    }
                    else{
                        viewModel.showAlert = true
                    }
                   
                }.alert(isPresented: $viewModel.showAlert){
                    Alert(title: Text("Error"), message: Text(viewModel.alertMessage))
                }
            }.padding()
        }
    }
}


//
//#Preview {
//    NewRuleItemView(newItemPresented: Binding(get:{
//        return true
//    }, set: {_ in
//    }))
//}
