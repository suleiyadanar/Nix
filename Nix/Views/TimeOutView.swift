//
//  TimeOutView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 6/11/24.
//

import SwiftUI

struct TimeOutView: View {
    @ObservedObject var viewModel: NewRuleItemViewViewModel
//    @Binding var isPresented: Bool  // Binding to control the presentation of the sheet

    var body: some View {
        VStack {
            HStack {
                Text("Time Out Allowed")
                    .font(.headline)
                    .padding()
                Menu {
                    ForEach(0..<24) { number in
                        Button("\(number)") {
                            viewModel.timeOutAllowed = number
                        }
                    }
                    Button("∞") {
                        viewModel.timeOutAllowed = Int.max
                    }
                } label: {
                    Text("\(viewModel.timeOutAllowed == Int.max ? "∞" : "\(viewModel.timeOutAllowed)")")
                }
                .padding()
            }
            
            VStack(alignment: .leading) {
                Text("Delay between Time Outs").font(.headline).padding()
                HStack {
                    Button(action: { viewModel.delay = .none }) {
                        Text("None")
                            .padding()
                            .background(viewModel.delay == .none ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    
                    Button(action: { viewModel.delay = .fifteen }) {
                        Text("15 mins")
                            .padding()
                            .background(viewModel.delay == .fifteen ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    Button(action: { viewModel.delay = .thirty }) {
                        Text("30 mins")
                            .padding()
                            .background(viewModel.delay == .thirty ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
                HStack {
                    Button(action: { viewModel.delay = .hour }) {
                        Text("1 hr")
                            .padding()
                            .background(viewModel.delay == .hour ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    Button(action: { viewModel.delay = .three_hour }) {
                        Text("3 hrs")
                            .padding()
                            .background(viewModel.delay == .three_hour ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Length of Time Outs").font(.headline).padding()
                HStack {
                    Button(action: { viewModel.timeOutLength = .one }) {
                        Text("1 min")
                            .padding()
                            .background(viewModel.timeOutLength == .one ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    Button(action: { viewModel.timeOutLength = .five }) {
                        Text("5 mins")
                            .padding()
                            .background(viewModel.timeOutLength == .five ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    Button(action: { viewModel.timeOutLength = .fifteen }) {
                        Text("15 mins")
                            .padding()
                            .background(viewModel.timeOutLength == .fifteen ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
                HStack {
                    Button(action: { viewModel.timeOutLength = .thirty }) {
                        Text("30 mins")
                            .padding()
                            .background(viewModel.timeOutLength == .thirty ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    Button(action: { viewModel.timeOutLength = .hour }) {
                        Text("1 hr")
                            .padding()
                            .background(viewModel.timeOutLength == .hour ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("Mode").font(.headline).padding()
                HStack {
                    Button(action: { viewModel.unlock = .math }) {
                        Text("Math Problem")
                            .padding()
                            .background(viewModel.unlock == .math ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    Button(action: { viewModel.unlock = .entry }) {
                        Text("Entry Prompt")
                            .padding()
                            .background(viewModel.unlock == .entry ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                }
            }
        }
        .padding()
    }
}
