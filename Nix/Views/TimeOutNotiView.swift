import SwiftUI
import FirebaseAuth
import Foundation

import SwiftUI
import Foundation

struct TimeOutNotiView: View {
    @StateObject private var viewModel = TimeOutNotiViewViewModel()
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp: Date = Date()

    @Binding var isPresented: Bool
    
    private func unlockText(for totalSeconds: Int) -> String {
           guard totalSeconds > 0 else { return "Unlock" }
           
           let hours = totalSeconds / 3600
           let minutes = (totalSeconds % 3600) / 60
           let seconds = totalSeconds % 60
           
           var components: [String] = []
           
           if hours > 0 {
               components.append("\(hours) hrs")
           }
           if minutes > 0 {
               components.append("\(minutes) mins")
           }
           if seconds > 0 {
               components.append("\(seconds) secs")
           }
           
           let timeString = components.joined(separator: " ")
           return "Unlock in \(timeString)"
       }
    
    var body: some View {
        
        VStack {
            HStack {
                            Button(action: {
                                // Action for the top-left button
                            }) {
                                Image(systemName: "cube.box")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }

                            Spacer()

                            Button(action: {
                                isPresented = false
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
            Spacer()

            VStack {
                Text("Time Out")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.blue)
                Text("Morning Me-Time")
                    .font(.system(size: 16))
                    .foregroundColor(.pink)
            }

            Spacer()

            if viewModel.message == "No more time outs available." {
                Text(viewModel.message)
                    .font(.system(size: 48, weight: .medium))
                    .padding(.bottom, 10)

                Button(action: {}) {
                    Text("Unlock")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
                .disabled(true) // Always disabled when "No more time outs available."
            } else {
                Text(viewModel.problem)
                    .font(.system(size: 48, weight: .medium))
                    .padding(.bottom, 10)
             
                TextField("", text: $viewModel.answer)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal, 50)
                Button(action: {
                    viewModel.checkAnswer()
//                    viewModel.startTimer()
                        
//                    timeOutModel.totalSeconds = viewModel.timerCount
//                    timeOutModel.startTimer(total:viewModel.timerCount)
                    
                    
                    
                }) {
                    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
                    Text(unlockText(for: viewModel.timerCount))

                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(viewModel.timerCount <= 0 ? Color.purple :  Color.gray)
                        .cornerRadius(30)
                    Text("viewMode.timerCount"+String(viewModel.timerCount))
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
                .disabled(viewModel.timerCount > 0) // Disable when timer is running
                .onChange(of: viewModel.shouldDismiss) {
                    if viewModel.shouldDismiss {
                        isPresented = false
                    }
                }
                        
            }

            if viewModel.message != "No more time outs available." {
                Text(viewModel.message)
            }

            Spacer()

            if viewModel.timerRunning {
                Text("available in \(viewModel.timerCount)s")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
            }
        }
//        .onChange(of: phase) {
//            let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
//
//            var totalSeconds =  userDefaults?.integer(forKey: "totalSeconds")
//            
//            if totalSeconds ?? 0 > 0 {
//                if phase == .background {
//                    lastActiveTimeStamp = Date()
//                    print("got here bg view")
//                }
//                if phase == .active {
//                    print("got here active view")
//                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
//                    if totalSeconds ?? 0 - Int(currentTimeStampDiff) <= 0 {
//                        userDefaults?.removeObject(forKey: "totalSeconds")
//                    }else{
//                        totalSeconds! -= Int(currentTimeStampDiff)
//                        viewModel.timerCount -= Int(currentTimeStampDiff)
//                    }
//                }
//                
//            }
//        }
        .onDisappear{
            let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

            lastActiveTimeStamp = Date()
            userDefaults?.set(lastActiveTimeStamp, forKey: "lastActiveTimer")
            print("got here bg view")
        }
        
        
//        .onDisappear{
//            timeOutModel.saveTimerData()
//        }
        .onAppear {

            let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
           
            if viewModel.timerCount != -1{
                viewModel.startTimer()
            }
            print("got here active view")
            viewModel.generateProblem()

            if let lastActiveTimeStamp = userDefaults?.object(forKey: "lastActiveTimer") as? Date {
                print("resuming")
                let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                var totalSeconds =  userDefaults?.integer(forKey: "totalSeconds")
                print("resume total seconds"+String(totalSeconds ?? -2))
                if totalSeconds ?? 0 - Int(currentTimeStampDiff) <= 0 {
                    print("removing totalSeconds key because ")
                    userDefaults?.removeObject(forKey: "totalSeconds")
                }else{
                    totalSeconds! -= Int(currentTimeStampDiff)
                    viewModel.timerCount -= Int(currentTimeStampDiff)
                    userDefaults?.set(viewModel.timerCount, forKey: "totalSeconds")

                }
                print("Last active timestamp: \(lastActiveTimeStamp)")
            } else {
                // Handle the case where the key doesn't exist or the value isn't a Date
                print("Key 'lastActiveTimer' does not exist or is not a Date")
            }
          
        }

    }
}
