//
//  PomodoroView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI
import DeviceActivity

struct PomodoroView: View {
    @StateObject var viewModel = PomodoroViewViewModel()
    var userId: String
   
    
    
    
    
    
    var body: some View {
        VStack{
            Text("Pomodoro Timer").font(.title2.bold()).padding()
            Text(viewModel.isBreak ? "Break" : "Pomodoro")
            Text(viewModel.timerStringValue)
                .font(.system(size:45, weight: .light))
                .animation(.none, value: viewModel.progress)
            HStack {
                Button {
                    viewModel.addNewTimer = true
                } label: {
                    Image(systemName: "gearshape.fill" )
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background{
                            Circle().fill(Color.purple)
                        }.shadow(color: Color.purple, radius: 8, x:0, y:0)
                }
                
                Button {
                    if !viewModel.isBreak {
                        if !viewModel.isStarted{
                            viewModel.startTimer()
                           
                        }else{
                            viewModel.stopTimer()
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                    } else {
                        if !viewModel.isStarted{
                            
                            viewModel.startBreak()
                            
                        }else{
                            viewModel.stopTimer()
                            
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                    }
                   
                } label: {
                    Image(systemName: !viewModel.isStarted  ? "play.fill" : "stop.fill")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background{
                            Circle().fill(Color.purple)
                        }.shadow(color: Color.purple, radius: 8, x:0, y:0)
                }
                
                Button {
                    
                    viewModel.changeState()
                    
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background{
                            Circle().fill(Color.purple)
                        }.shadow(color: Color.purple, radius: 8, x:0, y:0)
                }
                
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
                    item: $viewModel.item
                )
            }
            
            //            TotalActivityTabView()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(content: {
                ZStack {
                    Color.black
                        .opacity(viewModel.addNewTimer ? 0.25 : 0)
                        .onTapGesture {
                            viewModel.minutes = 25
                            viewModel.seconds = 0
                            viewModel.breakMinutes = 5
                            viewModel.breakSeconds = 0
                            viewModel.addNewTimer = false
                        }
                    NewTimerView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: viewModel.addNewTimer ? 0 : 400)
                }.animation(.easeInOut, value: viewModel.addNewTimer)
            })
            .onReceive(Timer.publish(every:1, on:.current, in:.common).autoconnect()){
                _ in
                if viewModel.isStarted {
                    viewModel.updateTimer()
                }
            }
//            .alert("Congrats", isPresented: $viewModel.isFinished){
//                Button("Start new", role: .cancel){
//                    viewModel.saveSettings()
//                    viewModel.addNewTimer = true
//                }
//                Button("Close", role: .destructive){
//                    viewModel.saveSettings()
//                }
//            }
            
    }
    
    
    
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15){
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            VStack() {
                
                HStack(){
                    Text("Pomodoro")
                    Text("\(viewModel.staticMinutes) min")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.horizontal, 20)
                        .padding(.vertical,12)
                        .background{
                            Capsule()
                                .fill(.white.opacity(0.07))
                        }.contextMenu {
                            ContextMenuOptions(maxValue: 60, minValue: 15, hint: "min") { value in
                                viewModel.staticMinutes = value
                            }
                        }
                    Text("\(viewModel.staticSeconds) s")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.horizontal, 20)
                        .padding(.vertical,12)
                        .background{
                            Capsule()
                                .fill(.white.opacity(0.07))
                        }
                        .contextMenu {
                            ContextMenuOptions(maxValue: 60, minValue: 0,hint: "sec") { value in
                                viewModel.staticSeconds = value
                            }
                        }
                }
                HStack(){
                    Text("Break")
                    Text("\(viewModel.staticBreakMinutes) min")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.horizontal, 20)
                        .padding(.vertical,12)
                        .background{
                            Capsule()
                                .fill(.white.opacity(0.07))
                        }.contextMenu {
                            ContextMenuOptions( maxValue: 60, minValue: 0,hint: "min") { value in
                                viewModel.staticBreakMinutes = value
                            }
                        }
                    Text("\(viewModel.staticBreakSeconds) s")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.horizontal, 20)
                        .padding(.vertical,12)
                        .background{
                            Capsule()
                                .fill(.white.opacity(0.07))
                        }
                        .contextMenu {
                            ContextMenuOptions(maxValue: 60, minValue: 0, hint: "sec") { value in
                                viewModel.staticBreakSeconds = value
                            }
                        }
                }
                
            }
            
            Button {
                viewModel.saveSettings()

            } label: {
                Text("Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background{
                        Capsule().fill(Color.purple)
                    }
            }
            .disabled(viewModel.minutes == 0 && viewModel.breakMinutes == 0)
            .opacity(viewModel.minutes == 0 && viewModel.breakMinutes == 0 ? 0.5 : 1)
            .padding(.bottom, 100)
        }.padding()
            .frame(maxWidth: .infinity)
//            .background{
//                RoundedRectangle(cornerRadius: 10, style: .continuous)
//                    .fill(Color.blue)
//                        .ignoresSafeArea()
//            }
    }
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, minValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
            ForEach(minValue...maxValue, id: \.self) { value in
                Button("\(value) \(hint)") {
                    onClick(value)
                }
            }
        }
    }

//
//#Preview {
//    PomodoroView()
//}
