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


struct RulesView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel : RulesViewViewModel
    @State private var selectedItem: RuleItem?
    @State private var userId : String
    @FirestoreQuery var items: [RuleItem] 

    
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

                         
                         // ITERATE THROUGH THE RULE ITEMS FETCHED FROM THE DATABASE
                         List(items) { item in
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
                                 Text(String(tokensArray.count))
                                     ForEach(0..<tokensArray.count, id: \.self) { index in
                                         Label(tokensArray[index])
                                     }
                                 
                             }
                             
                             // SHOW DELETE BUTTON WHEN A RULE ITEM IS SWIPED
                             .swipeActions {
                                 Button("Delete"){
                                     viewModel.delete(id: item.id)
                                 }
                                 .tint(.red)
                             }
                             
                             // EDITING THE EXISTING ITEM
                         }.sheet(isPresented: $viewModel.showingEditItemView) {
                                 NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, item:selectedItem)
                             Text(items[0].title)
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
                         ScrollView{

                         }
                     }.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                         .padding(.horizontal, 20)
                 Spacer()
             }.toolbar {
                 // TOOL BAR WITH THE OPTION TO ADD A CUSTOMIZED TEMPLATE
                 Button {
                     viewModel.showingNewItemView = true
                 } label: {
                     NavigationLink("add stuff", destination: NewRuleItemView(newItemPresented: $viewModel.showingNewItemView))
                     Image(systemName: "calendar")
                     Image(systemName: "gearshape.fill")
                 }.foregroundColor(colorScheme == .dark ? Color.white : Color.black)
             }
             .sheet(isPresented: $viewModel.showingNewItemView){
                 NewRuleItemView(newItemPresented: $viewModel.showingNewItemView)
             }
         }
     }
 }
