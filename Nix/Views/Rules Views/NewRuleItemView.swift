import SwiftUI
import DeviceActivity
import ManagedSettings
import FamilyControls

struct NewRuleItemView: View {
    @ObservedObject var viewModel = NewRuleItemViewViewModel()
    @State private var showingTimeOutSettings = false  // Track whether time out settings sheet is presented
    
    @State private var pickerIsPresented = false
    @ObservedObject var model = BlockedAppsModel()
    @Binding var newItemPresented: Bool
    @State var userId: String
    @State var item: RuleItem?
    @State var color: String = "swatch_lemon"

    @State private var errorMessage: String = ""
    
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let currentDate = Date()
    
    func savedSelection() -> FamilyActivitySelection? {
        guard let selectedData = item?.selectedData else {
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
            print("Failed to decode FamilyActivitySelection: \(error)")
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
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
                            viewModel.selectionType = item?.selectionType ?? ""
                            viewModel.mode = item.flatMap { NewRuleItemViewViewModel.RuleMode(rawValue: $0.mode) } ?? .regular
                            viewModel.unlock = item.flatMap { NewRuleItemViewViewModel.UnlockMethod(rawValue: $0.unlock) } ?? .math
                            viewModel.timeOutAllowed = item?.timeOutAllowed ?? Int.max
                            viewModel.delay = item.flatMap { NewRuleItemViewViewModel.DelayTime(rawValue: $0.delay) } ?? .none
                            viewModel.timeOutLength = item.flatMap { NewRuleItemViewViewModel.TimeoutLength(rawValue: $0.timeOutLength) } ?? .one
                            viewModel.intentionalHours = item?.intentionalHours ?? 0
                            viewModel.intentionalMinutes = item?.intentionalMinutes ?? 0
                            viewModel.color = item?.color ?? color
                        }
                    Button(action: {
                        viewModel.showingAppGroup.toggle()
                    }) {
                        Text("Blocked Apps")
                    }
                    .sheet(isPresented: $viewModel.showingAppGroup) {
                        BlockedAppsView(
                            userId: userId,
                            selectionType: $viewModel.selectionType,
                            selectedData: $viewModel.selectedData,
                            showingAppGroup: $viewModel.showingAppGroup,
                            item: $item
                        )
                    }
                    
                    Text(viewModel.selectionType)
                    Text(viewModel.selectedData)
                    ColorSwatchView(selection: $color)
                    DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(height: 50)
                        .onAppear {
                            viewModel.startTime = Date(timeIntervalSince1970: item?.startTime ?? Date().timeIntervalSince1970)
                        }
                    
                    DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(height: 50)
                        .onAppear {
                            viewModel.endTime = Date(timeIntervalSince1970: item?.endTime ?? Date().timeIntervalSince1970)
                        }
                    DatePicker("From", selection: $viewModel.fromDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                    
                    DatePicker("To", selection: $viewModel.toDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                    
                    VStack {
                        Text("Mode")
                        HStack {
                            Button(action: { viewModel.mode = .regular }) {
                                Text("Regular")
                                    .padding()
                                    .background(viewModel.mode == .regular ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }
                            Button(action: { viewModel.mode = .intentional }) {
                                Text("Intentional")
                                    .padding()
                                    .background(viewModel.mode == .intentional ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }
                            Button(action: { viewModel.mode = .strict }) {
                                Text("Strict")
                                    .padding()
                                    .background(viewModel.mode == .strict ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(50)
                            }
                        }
                    }
                    .padding(.vertical)
                    if (viewModel.mode == .regular){
                        Button(action: {
                                        showingTimeOutSettings = true  // Show time out settings sheet when button is tapped
                                    }) {
                                        Text("Time Out Settings")
                                    }
                                    .sheet(isPresented: $showingTimeOutSettings) {
                                        NavigationView {
                                                            TimeOutView(viewModel: viewModel)
                                                                .navigationTitle("Time Out Settings")
                                                                .navigationBarItems(trailing: Button("Done") {
                                                                    showingTimeOutSettings = false  // Dismiss the sheet when done
                                                                })
                                                        }                                }
                    }else if (viewModel.mode == .intentional){
                        HStack(){
                            Text("Hours")
                            Text("\(viewModel.intentionalHours) hr")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black.opacity(0.3))
                                .padding(.horizontal, 20)
                                .padding(.vertical,12)
                                .background{
                                    Capsule()
                                        .fill(.white.opacity(0.07))
                                }.contextMenu {
                                    ContextMenuOptions(maxValue: 23, hint: "hr") { value in
                                        viewModel.intentionalHours = value
                                    }
                                }
                            Text("Min")
                            Text("\(viewModel.intentionalMinutes) min")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black.opacity(0.3))
                                .padding(.horizontal, 20)
                                .padding(.vertical,12)
                                .background{
                                    Capsule()
                                        .fill(.white.opacity(0.07))
                                }
                                .contextMenu {
                                    ContextMenuOptions(maxValue: 60, hint: "min") { value in
                                        viewModel.intentionalMinutes = value
                                    }
                                }
                        }
                        
                    }
                  
                    
                    
                    ScrollView {
                        HStack {
                            ForEach(0..<daysOfWeek.count, id: \.self) { index in
                                Text(self.daysOfWeek[index])
                                    .frame(width: 40, height: 40)
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
                    // HERE
                    TLButton(text: "Save", background: .pink) {
                        var activityName = DeviceActivityName(rawValue: "\(viewModel.title)-\(viewModel.mode)-\(viewModel.intentionalHours)-\(viewModel.intentionalMinutes)")
                        let calendar = Calendar.current
                        var intervalStart = calendar.dateComponents([.hour, .minute], from: self.viewModel.startTime)
                        var intervalEnd = calendar.dateComponents([.hour, .minute], from: self.viewModel.endTime)
                        print("interval start", intervalStart)
                        print("interval end", intervalEnd)
                        let center = DeviceActivityCenter()
                        var schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false)
                        
                        if viewModel.selectedDays.isEmpty {
                            do {
                                try center.startMonitoring(activityName, during: schedule)
                                print("evnts fetch", center.events(for:activityName))
                                print("this is the activity running", center.activities)

                                print("monitoring")
                            } catch let error {
                                print("error \(error)")
                            }
                        } else {
                            for i in 0..<viewModel.selectedDays.count {
                                activityName = DeviceActivityName(rawValue: "\(viewModel.title)-\(viewModel.mode)-\(viewModel.intentionalHours)-\(viewModel.intentionalMinutes)" + String(i))
                                intervalStart.weekday = Array(viewModel.selectedDays)[i] + 1
                                intervalEnd.weekday = Array(viewModel.selectedDays)[i] + 1
                                schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: true)
                            }
                            do {
                                try center.startMonitoring(activityName, during: schedule)
                                print("this is the activity running", center.activities)

                                print("monitoring")
                            } catch let error {
                                print("error \(error)")
                            }
                        }
                        
                        if viewModel.canSave {
                            viewModel.color = color
                            viewModel.save()
                            newItemPresented = false
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Error"), message: Text(viewModel.alertMessage))
                    }
                }
                .padding()
            }
            .navigationTitle("New Rule Item")
        }
    }
}

@ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        ForEach(0...maxValue, id: \.self) { value in
            Button("\(value) \(hint)") {
                onClick(value)
            }
        }
    }

