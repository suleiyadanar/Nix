
import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var year = ""
    @Published var college = ""
    @Published var major = ""
    @Published var opt = false
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var goals = [""]
    @Published var unProdST = ""
    @Published var maxUnProdST = 0
    
    @Published var errorMessage: String = "" // Optional error message
    
    private let db = Firestore.firestore()
    
    init() {}
    
    func register() {
        print("firstname:\(firstName)",
              "college:\(college)",
              "year:\(year)",
              "major:\(major)",
              "opt:\(opt)",
              "username:\(username)",
              "email:\(email)",
              "password:\(password)")
        guard validate() else {
            print("failed validate")
            return
        }
        

        checkUsernameAvailability { [weak self] isAvailable in
            guard isAvailable else {
                self?.errorMessage = "Username is already taken."
                return
            }
            
            Auth.auth().createUser(withEmail: self?.email ?? "", password: self?.password ?? "") { result, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let userId = result?.user.uid else {
                    return
                }
                self?.insertUserRecord(id: userId)
            }
        }
    }
    
    private func insertUserRecord(id: String) {
        print("inserting")
        let newUser = User(id: id,
                           firstName: firstName,
                           username: username, email: email,
                           joined: Date().timeIntervalSince1970,
                           college: college,
                           year:year,
                           major:major,
                           opt: opt,
                           goals:goals,
        unProdST: unProdST,
        maxUnProdST: maxUnProdST)
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func checkUsernameAvailability(completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking username: \(error)")
                    completion(false)
                    return
                }
                
                if let snapshot = snapshot, snapshot.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }
    
    func isStrongPassword(_ password: String) -> Bool {
        // Check if password meets minimum length requirement
        guard password.count >= 8 else { return false }
        
        // Define character set requirements
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        let uppercaseTest = NSPredicate(format:"SELF MATCHES %@", uppercaseLetterRegex)
        
        let lowercaseLetterRegex = ".*[a-z]+.*"
        let lowercaseTest = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegex)
        
        let digitRegex = ".*[0-9]+.*"
        let digitTest = NSPredicate(format:"SELF MATCHES %@", digitRegex)
        
        let specialCharacterRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
        let specialCharacterTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegex)
        
        // Check if password meets all criteria
        return uppercaseTest.evaluate(with: password) &&
               lowercaseTest.evaluate(with: password) &&
               digitTest.evaluate(with: password) &&
               specialCharacterTest.evaluate(with: password)
    }
    
    func validate() -> Bool {
        errorMessage = ""
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              !college.trimmingCharacters(in: .whitespaces).isEmpty,
              !major.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all required fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        guard isStrongPassword(password) else {
            errorMessage = "Password must be at least 8 characters long and contain uppercase, lowercase, digit, and special characters."
            return false
        }
        
        return true
    }
}
