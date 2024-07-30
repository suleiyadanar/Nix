//
//  NixApp.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/15/24.
//

import SwiftUI
import FirebaseCore
import FamilyControls
import DeviceActivity
import FirebaseFirestore
import FirebaseAuth

private let thisWeek = DateInterval(start: Date(), end: Date())

@main struct NixApp: App {
    @State var user: User? = nil

    var userSettings = UserSettings()
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
    
    init() {
        FirebaseApp.configure()
//        applicationSignificantTimeChange(UIApplication.shared)
    }
    let center = AuthorizationCenter.shared
    

    
    @StateObject var pomodoroModel: PomodoroViewViewModel = .init()
    @StateObject var timeoutModel: TimeOutViewModel = .init()
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp: Date = Date()
  

    var body: some Scene {
        WindowGroup {
            ResponsiveView() { properties in
                MainView(props: properties)
                    .environmentObject(pomodoroModel)
                    .environmentObject(userSettings)
                    .environmentObject(timeoutModel)
                    .onAppear(){
                       
                        fetchUser { user in
                            if let user = user {
                                // Use the fetched user object
                                userDefaults?.set(user.maxUnProdST, forKey:"maxUnProdST")
                                
                                // Days since joined
                                let joinedDate = Date(timeIntervalSince1970: user.joined)
                                let currentDate = Date()

                                // Calculate the time difference in seconds
                                let timeDifference = currentDate.timeIntervalSince(joinedDate)

                                // Convert seconds to days
                                let daysSinceJoined = Int(timeDifference / (60 * 60 * 24))
                                
                                
                                userDefaults?.set(daysSinceJoined, forKey:"userDays")
                                
                                userDefaults?.set(user.team, forKey: "team")
                                print(user.team)
                                print(daysSinceJoined)
                                print("Fetched user: \(user.firstName)")
                            } else {
                                // Handle error or no user scenario
                                print("Failed to fetch user.")
                            }
                        }
                        
                    }

            }

        }.onChange(of: phase) {
            
            if pomodoroModel.isStarted {
                if phase == .background {
                    lastActiveTimeStamp = Date()
                }
                if phase == .active {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                    }else{
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
           
//            var totalSeconds =  userDefaults?.integer(forKey: "totalSeconds")
//
//            if totalSeconds ?? 0 > 0 {
//                if phase == .background {
//                    lastActiveTimeStamp = Date()
//                    userDefaults?.set(lastActiveTimeStamp, forKey: "lastActiveTimer")
//
//                    print("got here bg")
//                }
//                if phase == .active {
//                    print("got here active")
//                    totalSeconds =  userDefaults?.integer(forKey: "totalSeconds")
//
//                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
//                    if totalSeconds ?? 0 - Int(currentTimeStampDiff) <= 0 {
//                        userDefaults?.removeObject(forKey: "totalSeconds")
//                    }else{
//                        totalSeconds! -= Int(currentTimeStampDiff)
//                        userDefaults?.set(totalSeconds, forKey: "totalSeconds")
//                    }
//                }
//                
//            }
            
//            print("timeoutModel started is \(timeoutModel.isStarted)")
//            if timeoutModel.isStarted {
//                print("got here is starting")
//                if phase == .background {
//                    lastActiveTimeStamp = Date()
//                    print("got here bg")
//                }
//                if phase == .active {
//                    print("got here active")
//                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
//
//                    if timeoutModel.totalSeconds  - Int(currentTimeStampDiff) <= 0 {
//                        timeoutModel.isStarted = false
//                        timeoutModel.totalSeconds = 0
//                        timeoutModel.isFinished = true
//                    } else {
//                        timeoutModel.totalSeconds -= Int(currentTimeStampDiff)
//
//                    }
//                    print(timeoutModel.totalSeconds)
//                
//                }
//               
//              
//
//            }

                // sorry we can change this after i figure out how to change the placeholder text color for the
                // text input boxes bc it keeps changing when its light/dark mode and becoming invisible in dark mode
                

        }
    }
    func fetchUser(completion: @escaping (User?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                let user = User(
                    id: data["id"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    college: data["college"] as? String ?? "",
                    byear: data["byear"] as? String ?? "",
                    year: data["year"] as? String ?? "",
                    major: data["major"] as? String ?? "",
                    opt: data["opt"] as? Bool ?? false,
                    goals: data["goals"] as? [String] ?? [],
                    unProdST: data["unProdST"] as? String ?? "",
                    maxUnProdST: data["maxUnProdST"] as? Int ?? 0,
                    team: data["team"] as? String ?? ""
                )
                completion(user)
            }
        }
    }
       
    
//    THIS IS FOR UPDATING DATA AT MIDNIGHT!!!
//    TODO: at midnight check if the user exceed the time limit or not
//        logic: 
//    (1)in the device report extension set the user default value and set it to exceed: true
//    (2)in the main view appear at midnight make changes to the db 
        
    
//    func applicationSignificantTimeChange(_ application: UIApplication) {
//        // Get the current date
//        let currentDate = Date()
//        
//        // Create a calendar object using the ISO 8601 calendar system
//        let calendar = Calendar(identifier: .iso8601)
//        
//        // Get the day of the year for the current date
//        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: currentDate)
//        
//        // Print the day of the year
//        print("Day of the year:", dayOfYear ?? "Unknown")
//        
//        // Check if it's midnight
//        if calendar.isDateInToday(currentDate) {
//            // Perform your function at midnight
//            updateMaxUnProdSTIfNeeded()
//        }
//        
//        // Optionally, perform other tasks or updates in response to the significant time change
//        // For example, update UI elements or trigger specific functionality
//    }
//
//    func updateMaxUnProdSTIfNeeded() {
//        let newValue = 100 // Example new value to update
//        
//        guard let userId = Auth.auth().currentUser?.uid else {
//            return
//        }
//        
//        let db = Firestore.firestore()
//        let userRef = db.collection("users").document(userId)
//        
//        // Perform the update
//        userRef.updateData([
//            "maxUnProdST": newValue // Replace with your updated value
//        ]) { error in
//            if let error = error {
//                print("Error updating maxUnProdST: \(error.localizedDescription)")
//            } else {
//                print("maxUnProdST updated successfully.")
//            }
//        }
//    }
}
