import SwiftUI
import Foundation

struct TimeOutNotiView: View {
    @StateObject private var viewModel = TimeOutNotiViewModel()
    @Binding var isPresented: Bool  // New binding variable

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
            }) {
                Text("Unlock")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(viewModel.timerRunning ? Color.gray : Color.purple)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
            .disabled(viewModel.timerRunning)
            .onChange(of: viewModel.shouldDismiss) {
                if viewModel.shouldDismiss {
                            isPresented = false  // Dismiss the view
                        }
                    }
            Text(viewModel.message)

            Spacer()

            if viewModel.timerRunning {
                Text("available in \(viewModel.timerCount)s")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.startTimer()
            viewModel.generateProblem()
        }
    }
}
