//
//  RuleItemView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI
import ManagedSettings
import DeviceActivity


//// Define a function to convert the selectedApps string into an array of ApplicationToken objects
//func convertToOriginalTokensArray(selectedApps: String) -> [ApplicationToken]? {
//    guard let data = selectedApps.data(using: .utf8) else {
//        return nil
//    }
//    do {
//        let originalTokensArray = try JSONDecoder().decode([ApplicationToken].self, from: data)
//        return originalTokensArray
//    } catch {
//        print("Error decoding selectedApps string:", error)
//        return nil
//    }
//}

/// Template for a Control Item
struct RuleItemView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var item : RuleItem
    let iconName : String
    let actionBtnLogo: String
    let stroke: Double
    let fill: Double
    
    @State var originalTokensArray: [ApplicationToken]
    
//    init(item: RuleItem, iconName: String, actionBtnLogo: String, stroke: Double, fill: Double) {
//        self.item = item
//        self.iconName = iconName
//        self.actionBtnLogo = actionBtnLogo
//        self.stroke = stroke
//        self.fill = fill
//        
//        // Initialize originalTokensArray by converting selectedApps string
//        if let tokensArray = convertToOriginalTokensArray(selectedApps: item.selectedApps) {
//            self.originalTokensArray = tokensArray
//        } else {
//            // Handle the case where conversion fails, perhaps by providing a default value or an empty array
//            self.originalTokensArray = []
//        }
//    }
    
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName:iconName)
                    .background(
                    RoundedRectangle(cornerRadius:5)
                        .fill(Color(red: 0.8, green: 0.9, blue:0.9))
                        .frame(width:50, height:50))
                    .padding(.leading,30)
                Spacer()
                VStack(alignment: .leading){
                    Text(item.title).bold().padding(.bottom,2)
                    HStack{
                        ForEach(0..<originalTokensArray.count, id: \.self) { index in
                            Label(originalTokensArray[index]).labelStyle(.iconOnly)
                        }
                    }
                    HStack(){
                        Label("",systemImage:"clock")
                        Text("\(Date(timeIntervalSince1970: item.startTime).formatted(.dateTime.hour().minute()))")
                        Text("-")
                        Text("\(Date(timeIntervalSince1970: item.endTime).formatted(.dateTime.hour().minute()))")
                    }.font(.body)
                }
                .padding(15)
                
                Spacer(minLength:2)
                Button(){
                    // Add action for the button
                }label:{
                    Image(systemName:actionBtnLogo).padding(.trailing,15).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.6, green: 0.7, blue:0.9).opacity(fill))
                    .stroke(Color(red: 0.6, green: 0.7, blue:0.9).opacity(stroke), lineWidth: 4))
            .padding(.bottom, 10)
        }
    }
}
//#Preview {
//    RuleItemView(item: .init (
//    id: "123",
//    title: "Test",
//    startTime: Date().timeIntervalSince1970,
//    endTime: Date().timeIntervalSince1970,
//    selectedDays: [0,1,2]
//    ), iconName: "plus.circle.fill", actionBtnLogo: "pencil", stroke:1, fill:0)
//}
