import SwiftUI

struct TimeOutQuestionView: View {
    @State private var answer: String = ""
    @State private var timerCount: Int = 10
    @State private var timerRunning: Bool = true
    @State private var problem: String = ""
    @State private var correctAnswer: String = ""
    @State private var isCorrect: Bool = false
    @State private var message: String = ""
    
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
                    // Action for the top-right button
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
            
            Text(problem)
                .font(.system(size: 48, weight: .medium))
                .padding(.bottom, 10)
            
            TextField("", text: $answer)
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
                checkAnswer()
            }) {
                Text("Unlock")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(timerRunning ? Color.gray : Color.purple) // Change color conditionally
                    .cornerRadius(30)
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
            .disabled(timerRunning)
            
            Text(message) // Display message here
            
            Spacer()
            
            if timerRunning {
                Text("available in \(timerCount)s")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            startTimer()
            generateProblem()
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timerCount > 0 {
                self.timerCount -= 1
            } else {
                timer.invalidate()
                self.timerRunning = false
            }
        }
    }
    
    func generateProblem() {
        let randomNumber = Int.random(in: 1...9)
        let isLetters = Bool.random()
        
        if isLetters {
            problem = "Enter \(randomNumber) As"
            correctAnswer = String(repeating: "A", count: randomNumber)
        } else {
            problem = "Enter \(randomNumber) \(randomNumber)s"
            correctAnswer = String(repeating: "\(randomNumber)", count: randomNumber)
        }
    }
    
    func checkAnswer() {
        if answer == correctAnswer {
            isCorrect = true
            message = "Correct!"
            print("(correct)")
        } else {
            isCorrect = false
            message = "Incorrect. Try again!"
        }
    }
}
