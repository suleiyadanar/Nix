//
//  SelectAppViews.swift
//  Nix
//
//  Created by Su Lei Yadanar on 3/18/24.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings
import CoreData
extension DeviceActivityName {
    static let dailyT = Self("dailyT")
}

struct SelectAppViews: View {
    @State private var pickerIsPresented = false
    var apps: BlockedAppsModel?
    
    var body: some View {
                        Button {
                                    pickerIsPresented = true
                                } label: {
                                    Text("Select Apps")
                                }
                                .familyActivityPicker(
                                    isPresented: $pickerIsPresented,
                                    selection: $model.activitySelection
                        )
        .onChange(of: apps.activitySelection) { newValue, _ in
            saveSelectedFile()
        }
    }
    
    
    func saveSelectedFile(){
//        let blockedApps = UserDefaults(suiteName: "group.com.nix.Nix")!
//        blockedApps.set(Bundle.main.url(forResource: "BlockedAppsModel", withExtension: ".swift"), forKey: "appsModel")
//        let answer = blockedApps.url(forKey:"appsModel")
//        print(UserDefaults.standard.dictionaryRepresentation())
//        print("\(answer)")
//        blockedApps.synchronize()
        
        var userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")!
        userDefaults.setValue("user12345", forKey: "userId")
        userDefaults.synchronize()
        
//        var userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
        if let testUserId = userDefaults.object(forKey: "userId") as? String {
          print("User Id: \(testUserId)")
        }
        
        
        
        
        //                            let calendar = Calendar.current
        ////                            let intervalStart = calendar.dateComponents([.hour, .minute], from: self.viewModel.startTime)
        ////                            let intervalEnd = calendar.dateComponents([.hour, .minute], from: self.viewModel.endTime)
        //        let schedule = DeviceActivitySchedule(intervalStart:DateComponents(hour:0, minute: 0), intervalEnd: DateComponents(hour:23, minute: 59),repeats: true)
        //        let center = DeviceActivityCenter()
        //
        //                            do {
        //                                try center.startMonitoring(.dailyT, during: schedule)
        //                                print("monitoring")
        //                            } catch let error {
        //                                print("error\(error)")
        //                            }
        //       }
        
    }
    
    //#Preview {
    //    SelectAppViews()
    //}
}
