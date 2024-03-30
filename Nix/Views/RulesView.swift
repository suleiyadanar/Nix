import FirebaseFirestoreSwift
import SwiftUI
import ManagedSettings
import DeviceActivity


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

                         Text("Your Rules")
                             .font(.subheadline)
                             .fontWeight(.heavy)
                             .padding(.bottom, 20)
                         List(items) { item in
                             
                             Button(action:{
                                 self.selectedItem = item
                                 viewModel.showingEditItemView = true
                             }) {
                                 RuleItemView(item: item, iconName: "person", actionBtnLogo: "pencil", stroke:1 , fill:0, originalTokensArray: convertToOriginalTokensArray(selectedApps: item.selectedApps) ?? [] )
                             }
                             .swipeActions {
                                 Button("Delete"){
                                     viewModel.delete(id: item.id)
                                 }
                                 .tint(.red)
                             }
                             
                             
                             }.sheet(isPresented: $viewModel.showingEditItemView) {
                                 NewRuleItemView(newItemPresented: $viewModel.showingEditItemView, item:selectedItem)

                             }
                             
                             .listStyle(PlainListStyle())
 //                        ScrollView{
 //
 //
 //                        }
                     }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                         .padding(.horizontal, 20)


                     VStack(alignment:.leading){
                         Text("Rules Template")
                             .font(.subheadline)
                             .fontWeight(.heavy)
                             .padding(.vertical, 20)
                         ScrollView{
 //                            RuleItemView(iconName: "person", item: <#RuleItem#>, task: "Morning Focus", startTimeOfDay: "AM", start: "2:32", endTimeOfDay: "PM", end:"5:32", actionBtnLogo: "plus.circle.fill", stroke:0 , fill:1 )
 //                            RuleItemView(iconName: "person", task: "Morning Focus", startTimeOfDay: "AM", start: "2:32", endTimeOfDay: "PM", end:"5:32",actionBtnLogo: "plus.circle.fill", stroke:0 , fill:1)
 //                            RuleItemView(iconName: "person", task: "Morning Focus", startTimeOfDay: "AM", start: "2:32", endTimeOfDay: "PM", end:"5:32",actionBtnLogo: "plus.circle.fill", stroke:0 ,fill:1)
 //                            RuleItemView(iconName: "person", task: "Morning Focus", startTimeOfDay: "AM", start: "2:32", endTimeOfDay: "PM", end:"5:32",actionBtnLogo: "plus.circle.fill", stroke:0 ,fill:1)
 //                            RuleItemView(iconName: "person", task: "Morning Focus", startTimeOfDay: "AM", start: "2:32", endTimeOfDay: "PM", end:"5:32",actionBtnLogo: "plus.circle.fill", stroke:0 ,fill:1)
                         }
                     }.frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                         .padding(.horizontal, 20)

                 Spacer()
             }.toolbar {
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
