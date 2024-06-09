//
//  PomodoroView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI

struct PomodoroView: View {
    @StateObject var viewModel = PomodoroViewViewModel()
    
    var body: some View {
        VStack{
            Text("Pomodoro Timer").font(.title2.bold())
            
            Text(viewModel.timerStringValue)
                .font(.system(size:45, weight: .light))
                .animation(.none, value: viewModel.progress)
            
            Button {
                if viewModel.isStarted {
                    viewModel.stopTimer()
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
                }else{
                    viewModel.addNewTimer = true
                }
            } label: {
                Image(systemName: !viewModel.isStarted ? "timer" : "stop.fill")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background{
                        Circle().fill(Color.purple)
                    }.shadow(color: Color.purple, radius: 8, x:0, y:0)
            }
            //            TotalActivityTabView()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .overlay(content: {
                ZStack {
                    Color.black
                        .opacity(viewModel.addNewTimer ? 0.25 : 0)
                        .onTapGesture {
                            viewModel.minutes = 0
                            viewModel.seconds = 0
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
            .alert("Congrats", isPresented: $viewModel.isFinished){
                Button("Start new", role: .cancel){
                    viewModel.stopTimer()
                    viewModel.addNewTimer = true
                }
                Button("Close", role: .destructive){
                    viewModel.stopTimer()
                }
            }
            
    }
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15){
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            HStack(){
               
                Text("\(viewModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical,12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }.contextMenu {
                        ContextMenuOptions(maxValue: 60, hint: "min") { value in
                            viewModel.minutes = value
                        }
                    }
                Text("\(viewModel.seconds) s")
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
                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in
                            viewModel.seconds = value
                        }
                    }
            }
            Button {
                viewModel.startTimer()
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
            .disabled(viewModel.seconds == 0)
            .opacity(viewModel.seconds == 0 ? 0.5 : 1)
            .padding(.bottom, 100)
        }.padding()
            .frame(maxWidth: .infinity)
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.blue)
                        .ignoresSafeArea()
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
    }

//
//#Preview {
//    PomodoroView()
//}
