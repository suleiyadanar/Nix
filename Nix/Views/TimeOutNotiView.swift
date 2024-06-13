import SwiftUI
import FirebaseAuth
import DeviceActivity

import FirebaseFirestore
import FirebaseFirestoreSwift

// Assuming Firestore has been properly configured in your app
let db = Firestore.firestore()

// Define the function to fetch RuleItem by title
// Define a function to fetch the delay of a RuleItem by title


struct TimeOutNotiView: View {
    @State private var answer: String = ""
    @State private var timerCount: Int = 10
    @State private var timerRunning: Bool = true
    @State private var problem: String = ""
    @State private var correctAnswer: Int = 0
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
            
            if timerCount > 0 {
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
        let randomNumber1 = Int.random(in: 10...99)
        let randomNumber2 = Int.random(in: 10...99)
        let isMultiplication = Bool.random()
        
        if isMultiplication {
            problem = "\(randomNumber1) × \(randomNumber2)"
            correctAnswer = randomNumber1 * randomNumber2
        } else {
            problem = "\(randomNumber1) + \(randomNumber2)"
            correctAnswer = randomNumber1 + randomNumber2
        }
    }
    
    func getTimeOutLengthWithTitle(uId: String, activityName: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("rules")
            .whereField("title", isEqualTo: activityName)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    // Handle the case where there are no documents found
                    let noDocumentsError = NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No documents found with the specified title."])
                    completion(.failure(noDocumentsError))
                    return
                }
                
                for document in documents {
                    if let timeOutLength = document.data()["timeOutLength"] as? Int {
                        completion(.success(timeOutLength))
                        return
                    } else {
                        let missingFieldError = NSError(domain: "FirestoreError", code: 400, userInfo: [NSLocalizedDescriptionKey: "timeOutLength field is missing or not an integer in document ID: \(document.documentID)"])
                        completion(.failure(missingFieldError))
                        return
                    }
                }
            }
    }
    
    func checkAnswer() {
        if let userAnswer = Int(answer) {
            if userAnswer == correctAnswer {
                isCorrect = true
                
                let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
                
                let ruleTitle = userDefaults?.object(forKey: "activeApp") as! String
                
                print("rule title")
                guard let userId = Auth.auth().currentUser?.uid else { return }
                
                
                getTimeOutLengthWithTitle(uId: userId, activityName: ruleTitle) { result in
                    switch result {
                    case .success(let timeOutLength):
                        userDefaults?.removeObject(forKey: "timeout")
                        let now = Date()
                        let start = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
                        let end = Calendar.current.dateComponents([.hour, .minute, .second], from: now.advanced(by: 15*60))
                        let center = DeviceActivityCenter()
                        
                        let activityName = DeviceActivityName(rawValue: "breakTime")
                        let schedule = DeviceActivitySchedule(
                            intervalStart: start,
                            intervalEnd: end,
                            repeats: false,
                            warningTime: DateComponents(minute: 15 - timeOutLength)
                        )
                        
                        do {
                            try center.startMonitoring(activityName, during: schedule)
                            print("Break happening")
                        } catch let error {
                            print("Error starting monitoring: \(error)")
                        }
                        
                        message = "Correct!"
                    case .failure(let error):
                        print("Error getting timeOutLength: \(error.localizedDescription)\(ruleTitle)")
                        message = "Error retrieving timeOutLength. Try again!\(error.localizedDescription)\(ruleTitle)"
                    }
                }
            }else {
                isCorrect = false
                message = "Incorrect. Try again!"
            }
        }
    }
}
