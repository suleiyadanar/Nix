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
        let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")!
        guard let data = userDefaults.object(forKey: "selectedApps") as? Data else {
                return nil
        }
        print("data here",data)
        return try? JSONDecoder().decode(
                FamilyActivitySelection.self,
                from: data
            )
        }
    
    var body: some View {
        VStack {
            Text("New Rule")
            Text(String(newItemPresented))
            VStack {
                
                TextField("Title", text: $viewModel.title)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                    .onAppear {
                                        viewModel.id = item?.id ?? ""
                                        viewModel.title = item?.title ?? ""}
                
                // SELECT START TIME
                DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
                    .onAppear {
                        viewModel.startTime = Date(timeIntervalSince1970: item?.startTime ?? TimeInterval())
                    }
                
                // SELECT END TIME
                DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(height: 50)
                    .onAppear {
                        viewModel.endTime = Date(timeIntervalSince1970: item?.endTime ?? TimeInterval())
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
                   
                    let activityName = DeviceActivityName(rawValue: "\(viewModel.title)")
                   
                    let calendar = Calendar.current
                    let intervalStart = calendar.dateComponents([.hour, .minute], from: self.viewModel.startTime)
                    let intervalEnd = calendar.dateComponents([.hour, .minute], from: self.viewModel.endTime)
                    let center = DeviceActivityCenter()
                    let schedule = DeviceActivitySchedule(intervalStart:intervalStart, intervalEnd: intervalEnd,repeats: false)
                    
//                    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
                    
                    do {
                        try center.startMonitoring(activityName, during: schedule)
                        print("monitoring")
                    } catch let error {
                        print("error\(error)")
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
                    Alert(title: Text("Error"), message: Text("Please fill in all fields and select end time that is after the start time."))
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
