import SwiftUI
import FirebaseAuth
import DeviceActivity
import FirebaseFirestore
import FirebaseFirestoreSwift

class TimeOutNotiViewViewModel: ObservableObject {
    @StateObject var timeOutModel = TimeOutViewModel()

    @Published var answer: String = ""
    @Published var timerCount: Int = -1
    @Published var timerRunning: Bool = false
    @Published var totalTimeOut: Int = 0
    @Published var problem: String = ""
    @Published var correctAnswer: Int = 0
    @Published var correctAnswerEntry: String = ""
    @Published var isCorrect: Bool = false
    @Published var message: String = ""
    @Published var shouldDismiss: Bool = false

    let db = Firestore.firestore()
    private var timer: Timer?
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")
    var ruleTitle: String

    init() {
        self.ruleTitle = ""
        
        
        // Fetch ruleTitle from UserDefaults
        let rawRuleTitle = userDefaults?.string(forKey: "activeApp") ?? ""
        self.ruleTitle = rawRuleTitle.split(separator: "-").first.map(String.init) ?? rawRuleTitle
        
        
        if let totalSeconds = userDefaults?.integer(forKey: "totalSeconds"), totalSeconds > 0 {
            print("timer exists so getting data")
            timerCount = totalSeconds
        }else{
           
                print("no timer exists so fetching delay")
            if timerCount != -1 {
                self.fetchDelay()
                
            }else {
                self.timerCount = 0
                // Continue with other initialization
                self.checkTimeOutAllowed()
                //              self.startTimer()
                self.generateProblem()
            }
        }
      }

    func fetchDelay(){
        // Fetch delay and set timerCount
        guard let userId = Auth.auth().currentUser?.uid else { return }

        getDelay(uId: userId) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let delay):
                print("success getting delay ")
                userDefaults?.set(delay*60, forKey: "totalSeconds")
                if timerCount >= 0 {
                    print("success getting delay ")
                    self.timerCount=delay*60
                }
            case .failure(let error):
                print("Error fetching delay: \(error.localizedDescription)")
                // Handle error if needed
            }
            
            // Continue with other initialization
            self.checkTimeOutAllowed()
            //              self.startTimer()
            self.generateProblem()
        }
    }
    func checkTimeOutAllowed() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        print("checking time out allowed")
        getTimeOutAllowed(uId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let timeOutAllowed):
                self.userDefaults?.set(timeOutAllowed, forKey: "timeOutAllowed")
                self.totalTimeOut = timeOutAllowed
                print("timeOutAllowed: \(timeOutAllowed)")
                if timeOutAllowed <= 0 {
                    self.message = "No more time outs available."
                    self.timerRunning = false
                }
            case .failure(let error):
                self.message = "Error retrieving timeOutAllowed: \(error.localizedDescription), \(self.ruleTitle)"
                print(self.ruleTitle)
                print("Error retrieving timeOutAllowed: \(error.localizedDescription)")
            }
        }
    }

    func startTimer() {
        print("starting timer")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            var totalSeconds =  userDefaults?.integer(forKey: "totalSeconds")
            print("totalSeconds"+String(totalSeconds ?? -2))
            timerCount = totalSeconds ?? 0
            if totalSeconds ?? 0 > 0 {
                self.timerRunning = true
                print("-1")
                totalSeconds! -= 1
                timerCount -= 1
                userDefaults?.set(totalSeconds, forKey: "totalSeconds")
            } else {
                timer.invalidate()
                userDefaults?.removeObject(forKey: "totalSeconds")
                userDefaults?.removeObject(forKey: "lastActiveTimer")
                print("timer is done so removing keys")
                
            }
        }
    }

    func generateProblem() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        getUnlockWithTitle(uId: userId, activityName: ruleTitle) { result in
            switch result {
            case .success(let unlock):
                switch unlock {
                case "Math Problem":
                    self.generateProblemMath()
                case "Entry Prompt":
                    self.generateProblemEntry()
                default:
                    print("Unknown unlock type")
                }
            case .failure(let error):
                print("Error fetching unlock: \(error.localizedDescription)")
            }
        }
    }

    func checkAnswer() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        getUnlockWithTitle(uId: userId, activityName: ruleTitle) { result in
            switch result {
            case .success(let unblock):
                switch unblock {
                case "Math Problem":
                    self.checkAnswerMath()
                case "Entry Prompt":
                    self.checkAnswerEntry()
                default:
                    print("Unknown unblock type")
                }
                if self.isCorrect {
                    if (self.totalTimeOut-1 > 0){
                        if let totalSeconds = self.userDefaults?.integer(forKey: "totalSeconds"), totalSeconds > 0 {
                            print("timer exists so getting data")
                            self.timerCount = totalSeconds
                        }else{
                            print("no timer exists so fetching delay")
                            self.fetchDelay()
                        }
                        self.startTimer()
                    }else{
                        print("self.message check not pass: \(self.message)")

                    }

                                }
            case .failure(let error):
                print("Error fetching unblock: \(error.localizedDescription)")
            }
        }
    }

    func generateProblemMath() {
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

    func generateProblemEntry() {
        let randomNumber = Int.random(in: 1...9)
        let isLetters = Bool.random()

        if isLetters {
            problem = "Enter \(randomNumber) As"
            correctAnswerEntry = String(repeating: "A", count: randomNumber)
        } else {
            problem = "Enter \(randomNumber) \(randomNumber)s"
            correctAnswerEntry = String(repeating: "\(randomNumber)", count: randomNumber)
        }
    }

    func checkAnswerMath() {
        if let userAnswer = Int(answer), userAnswer == correctAnswer {
            setCorrectAnswerState()
        } else {
            setIncorrectAnswerState()
        }
    }

    func checkAnswerEntry() {
        if answer == correctAnswerEntry {
            setCorrectAnswerState()
        } else {
            setIncorrectAnswerState()
        }
    }

    private func setCorrectAnswerState() {
        isCorrect = true
        message = "Correct!"
        handleCorrectAnswer()
    }

    private func setIncorrectAnswerState() {
        isCorrect = false
        message = "Incorrect. Try again!"
    }

    private func handleCorrectAnswer() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        getTimeOutAllowed(uId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let timeOutAllowed):
                if timeOutAllowed == Int.max {
                    // Skip decrement and proceed to schedule break
                    self.getTimeOutLengthWithTitle(uId: userId, activityName: self.ruleTitle) { result in
                        switch result {
                        case .success(let timeOutLength):
                            self.scheduleBreak(timeOutLength: timeOutLength)
                            self.message = "Correct!"
                            self.shouldDismiss = true
                        case .failure(let error):
                            self.message = "Error retrieving timeOutLength. Try again! \(error.localizedDescription)"
                            print("Error getting timeOutLength: \(error.localizedDescription)")
                        }
                    }
                } else {
                    // Proceed with decrementing timeOutAllowed
                    self.decrementTimeOutAllowed(uId: userId) { result in
                        switch result {
                        case .success(let newCount):
                            // Save the updated timeOutAllowed to UserDefaults
                            self.userDefaults?.set(newCount, forKey: "timeOutAllowed")
                            self.totalTimeOut = newCount
                            if newCount >= 0 {
                                self.getTimeOutLengthWithTitle(uId: userId, activityName: self.ruleTitle) { result in
                                    switch result {
                                    case .success(let timeOutLength):
                                        self.scheduleBreak(timeOutLength: timeOutLength)
                                        self.message = "Correct!"
                                        self.shouldDismiss = true
                                    case .failure(let error):
                                        self.message = "Error retrieving timeOutLength. Try again! \(error.localizedDescription)"
                                        print("Error getting timeOutLength: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                self.message = "No more time outs available."
                            }
                        case .failure(let error):
                            self.message = "Error decrementing time out: \(error.localizedDescription)"
                            print("Error decrementing time out: \(error.localizedDescription)")
                        }
                    }
                }
            case .failure(let error):
                self.message = "Error retrieving timeOutAllowed: \(error.localizedDescription)"
                print("Error retrieving timeOutAllowed: \(error.localizedDescription)")
            }
        }
    }

    private func scheduleBreak(timeOutLength: Int) {
        let center = DeviceActivityCenter()
        let activityName = DeviceActivityName(rawValue: "breakTime")
        let now = Date()
        let start = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
        let end = Calendar.current.dateComponents([.hour, .minute, .second], from: now.advanced(by: Double(timeOutLength < 15 ? 15 : timeOutLength) * 60))

        let schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: false,
            warningTime: timeOutLength < 15 ? DateComponents(minute: 15 - timeOutLength) : nil
        )

        do {
            try center.startMonitoring(activityName, during: schedule)
            print("Break happening")
        } catch let error {
            print("Error starting monitoring: \(error)")
        }
    }

    func getTimeOutLengthWithTitle(uId: String, activityName: String, completion: @escaping (Result<Int, Error>) -> Void) {
        fetchDocumentField(uId: uId, activityName: activityName, fieldName: "timeOutLength", completion: completion)
    }

    func getUnlockWithTitle(uId: String, activityName: String, completion: @escaping (Result<String, Error>) -> Void) {
        fetchDocumentField(uId: uId, activityName: activityName, fieldName: "unlock", completion: completion)
    }

    func getTimeOutAllowed(uId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        fetchDocumentField(uId: uId, activityName: ruleTitle, fieldName: "timeOutAllowed", completion: completion)
    }
    func getDelay(uId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        fetchDocumentField(uId: uId, activityName: ruleTitle, fieldName: "delay", completion: completion)
    }
    

    func decrementTimeOutAllowed(uId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let userDocument = db.collection("users").document(uId)
        let rulesCollection = userDocument.collection("rules")

        rulesCollection.whereField("title", isEqualTo: ruleTitle).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents, let document = documents.first else {
                let noDocumentsError = NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No documents found with the specified title."])
                completion(.failure(noDocumentsError))
                return
            }

            var timeOutAllowed = document.data()["timeOutAllowed"] as? Int ?? 0

            if timeOutAllowed >= 0 && timeOutAllowed != Int.max {
                timeOutAllowed -= 1
                document.reference.updateData(["timeOutAllowed": timeOutAllowed]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(timeOutAllowed))
                    }
                }
            } else {
                completion(.success(timeOutAllowed))
            }
        }
    }

    private func fetchDocumentField<T>(uId: String, activityName: String, fieldName: String, completion: @escaping (Result<T, Error>) -> Void) {
        db.collection("users")
            .document(uId)
            .collection("rules")
            .whereField("title", isEqualTo: activityName)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    let noDocumentsError = NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No documents found with the specified title."])
                    completion(.failure(noDocumentsError))
                    return
                }

                for document in documents {
                    if let fieldValue = document.data()[fieldName] as? T {
                        completion(.success(fieldValue))
                        return
                    } else {
                        let missingFieldError = NSError(domain: "FirestoreError", code: 400, userInfo: [NSLocalizedDescriptionKey: "\(fieldName) field is missing or not of expected type in document ID: \(document.documentID)"])
                        completion(.failure(missingFieldError))
                        return
                    }
                }
            }
    }
}
