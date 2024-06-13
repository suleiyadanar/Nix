import FirebaseFirestoreSwift
import SwiftUI
import ManagedSettings
import DeviceActivity


// View for rules tab in the tab bar
// Define a function to convert the selectedApps string into an array of ApplicationToken objects
func convertToOriginalTokensArray(selectedApps: String) -> [ApplicationToken]? {
    guard let data = selectedApps.data(using: .utf8) else {
        return nil
    }
    do {
        let originalTokensArray = try JSONDecoder().decode([ApplicationToken].self, from: data)
        return originalTokensArray
    } catch {
        print("Error decoding selectedApps string:", error)
        return nil
    }
}

// Model of the pre-made template item


func formatTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }


func loadJson(fileName: String) -> [RuleItem]? {
    let decoder = JSONDecoder()
    print("bundle path", Bundle.main.bundlePath)
    print("bundle url")
    
    // Step 1: Attempt to get the URL of the JSON file
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("oof")
        return nil
    }

    // Step 2: Attempt to load data from the URL
    do {
        let data = try Data(contentsOf: url)
        // Step 3: Attempt to decode JSON data into templateItem
        do {
            let template = try decoder.decode([RuleItem].self, from: data)
            return template
        } catch {
            return nil
        }
    } catch {
        return nil
    }
}

struct RulesView: View {
    @State private var showSheet = false

    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel : RulesViewViewModel
    @State private var selectedItem: RuleItem?
    @State private var selectedTemplate: RuleItem?
    @State private var userId : String
    @FirestoreQuery var items: [RuleItem]

    
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//    let templates = loadJson(fileName:"templates")
    // USES THE USERID TO
    // (1) fetch the rule items of the user
    // (2) populate the RulesViewViewModel with the userId
     init(userId: String){
         self._items = FirestoreQuery(collectionPath:"users/\(userId)/rules")
         self._viewModel = StateObject(
         wrappedValue: RulesViewViewModel(userId: userId))
         self.userId = userId
     }

     var body: some View {

         NavigationView {
             VStack(){
                     VStack(alignment:.leading){
                         // RULES SPECIFIC TO THE USER
                         Text("Your Rules")
                             .font(.subheadline)
                             .fontWeight(.heavy)
                             .padding(.bottom, 20)
                         Text(String(viewModel.showingEditItemView))
                         Text(userId)
                         
                         // ITERATE THROUGH THE RULE ITEMS FETCHED FROM THE DATABASE
                         
                         Text(String(items.count))
                         List(items.sorted(by: { $0.startTime < $1.startTime })) { item in
                             Button(action:{
                                 self.selectedItem = item
                                 viewModel.showingEditItemView = true
                             }) {
//                                 RuleItemView(item: item, iconName: "person", actionBtnLogo: "pencil", stroke:1 , fill:0, originalTokensArray: convertToOriginalTokensArray(selectedApps: item.selectedApps) ?? [] )
                                 Text(item.title)
                                 Text("\(Date(timeIntervalSince1970: item.startTime).formatted(.dateTime.hour().minute()))")
                                 Text("-")
                                 Text("\(Date(timeIntervalSince1970: item.endTime).formatted(.dateTime.hour().minute()))")
                                 let tokensArray = convertToOriginalTokensArray(selectedApps: item.selectedApps) ?? []
                                 
                                 Text(String(tokensArray.count)+" apps blocked")
//                                     ForEach(0..<tokensArray.count, id: \.self) { index in
//                                         Label(tokensArray[index])
//                                     }
                                 
                                 if item.selectedDays == [1,2,3,4,5]{
                                     Text("Weekdays")
                                 }else if (item.selectedDays == [0,6]) {
                                     Text("Weekends")
                                 }else if (item.selectedDays == [0,1,2,3,4,5,6]) {
                                     Text("Everyday")
                                 }else{
                                     ForEach(0..<item.selectedDays.count, id: \.self) { index in
                                         Text(daysOfWeek[item.selectedDays[index]])
                                     }
                                 }
                                 
                             }
                             
                             // SHOW DELETE BUTTON WHEN A RULE ITEM IS SWIPED
                             .swipeActions {
                                 Button("Delete"){
                                     let center = DeviceActivityCenter()

                                     let activityName = DeviceActivityName(rawValue: "\(item.title)")
                                     center.stopMonitoring([activityName])
                                     print("stop monitoring")
                                     viewModel.delete(id: item.id)
                                 }
                                 .tint(.red)
                             }
                             
                             // EDITING THE EXISTING ITEM
                         }.sheet(isPresented: $viewModel.showingEditItemView) {
                             NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, newTemplate: viewModel.showingTemplateView, userId: userId, item:selectedItem)
                             }
                             .listStyle(PlainListStyle())
                     }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                         .padding(.horizontal, 20)
                     
                     // TODO : MAYBE A SEPARATE PAGE FOR THE TEMPLATES LIBRARY
                     VStack(alignment:.leading){
                         Text("Rules Template")
                             .font(.subheadline)
                             .fontWeight(.heavy)
                             .padding(.vertical, 20)
//                         ForEach(0..<templates) { index in
//                             Text(templates.items[index])
//                         }
                         
                         
                         if let templates = loadJson(fileName: "templates") {
                                     VStack(alignment: .leading) {
//
                                         List(templates) { template in
                                             
                                             Button(action:{
                                                 self.selectedItem = template
                                                 viewModel.showingTemplateView = true
                                                 viewModel.showingEditItemView = true
                                             }) {
                                                 Text("ID: \(template.id)")
                                                                                          Text("Title: \(template.title)")
                                                                                          Text("Start Time: \(formatTime(template.startTime))")
                                                                                          Text("End Time: \(formatTime(template.endTime))")
                                                                                          Text("Selected Days: \(template.selectedDays)")
                                             }
                                         }.sheet(isPresented: $viewModel.showingEditItemView) {
                                             NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, newTemplate: viewModel.showingTemplateView ,userId: userId, item:selectedItem)
                                         }
                                         .listStyle(PlainListStyle())
                                     }
                                     .padding()
                                 } else {
                                     Text("Failed to load JSON file.")
                                 }
                         
                         
                     }.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                         .padding(.horizontal, 20)
                 Spacer()
             }.toolbar {
                 // TOOL BAR WITH THE OPTION TO ADD A CUSTOMIZED TEMPLATE
                 Button {
                     viewModel.showingNewItemView = true
                 } label: {
                     NavigationLink("add stuff", destination: NewRuleItemView(newItemPresented: $viewModel.showingNewItemView, newTemplate: viewModel.showingTemplateView, userId: userId))
                     Image(systemName: "calendar")
                     Image(systemName: "gearshape.fill")
                 }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
             }
             .sheet(isPresented: $viewModel.showingNewItemView){
                 NewRuleItemView(newItemPresented: $viewModel.showingNewItemView, newTemplate: viewModel.showingTemplateView, userId: userId)
             }
         }.onAppear {
             NotificationCenter.default.addObserver(forName: NSNotification.Name("NotificationTapped"), object: nil, queue: .main) { _ in
                 self.showSheet = true
             }
         }
         .sheet(isPresented: $showSheet) {
             TimeOutNotiView()
         }
     }
 }
