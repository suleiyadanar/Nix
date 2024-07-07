import SwiftUI
import SwiftCSV


struct RegisterView: View {
    @EnvironmentObject var userSettings: UserSettings

    @StateObject var viewModel = RegisterViewViewModel()
    @State private var optIn: Bool = false
    @State private var navigate: Bool = false
    @State private var isPopoverPresented: Bool = false
    let academicYears = ["Freshman", "Sophomore", "Junior", "Senior", "Associate", "Master's", "PhD", "PostDoc"]

    @State private var universities: [String] = []
    @State private var searchText: String = ""
    @State private var showList: Bool = false
    @State private var isLoading: Bool = false
    @State private var filteredUniversities: [String] = []
    @State private var showCustomUniversityField: Bool = false
    @State private var customUniversityName: String = ""
    
    @State private var selectedDate = Date() // Track selected date
    
    var body: some View {
            ScrollView {
                if universities.isEmpty {
                    Text("Loading...")
                        .onAppear {
                            loadCSV()
                        }
                } else {
                    VStack {
                        HStack {
                            Text("Creating your account for you...")
                                .font(.system(size: 30))
                                .bold()
                                .padding(.leading, 15)
                            Spacer()
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding(.top, 8)
                            }
                        }
                        
                        // Login Form
                        VStack {
                            VStack {
                                HStack {
                                    Text("Username*")
                                        .foregroundColor(Color.blue)
                                        .font(.system(size: 15))
                                        .bold()
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                                
                                TextField("Username", text: $viewModel.username)
                                    .padding(.horizontal,20)
                                    .frame(width: 250, height: 40)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .padding(.bottom, 10)
                                
                                HStack {
                                    Text("Password*")
                                        .foregroundColor(Color.blue)
                                        .font(.system(size: 15))
                                        .bold()
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                                SecureField("Strong Password", text: $viewModel.password)
                                    .padding(.horizontal,20)
                                    .frame(width: 250, height: 40)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .padding(.bottom, 10)
                                
                                HStack {
                                    Text("Educational Email Address*")
                                        .foregroundColor(Color.blue)
                                        .font(.system(size: 15))
                                        .bold()
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                                TextField("jane@college.edu", text: $viewModel.email)
                                    .padding(.horizontal,20)
                                    .frame(width: 250, height: 40)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .autocapitalization(.none)
                                    .padding(.bottom, 10)
                                
                                HStack {
                                    Text("College*")
                                        .foregroundColor(Color.blue)
                                        .font(.system(size: 15))
                                        .bold()
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                                
                                // Searchable university picker
                                TextField("Search for your university", text: $searchText)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onChange(of: searchText, perform: { _ in
                                        filterUniversities()
                                    })
                                    .onTapGesture {
                                        showList = true
                                    }
                                
                                if showList {
                                    if isLoading {
                                        ProgressView()
                                    } else {
                                        List {
                                            ForEach(filteredUniversities, id: \.self) { university in
                                                Text(university)
                                                    .onTapGesture {
                                                        if university == "Other" {
                                                            viewModel.college = "Other"
                                                            searchText = university
                                                            showList = false
                                                            hideKeyboard()
                                                            
                                                            // Ensure showCustomUniversityField is shown
                                                            showCustomUniversityField = true
                                                        } else {
                                                            viewModel.college = university
                                                            searchText = university
                                                            showList = false
                                                            hideKeyboard()
                                                            
                                                            // Ensure showCustomUniversityField is hidden when other university is selected
                                                            showCustomUniversityField = false
                                                            customUniversityName = "" // Clear custom university name if previously set
                                                        }
                                                    }
                                                    .padding(.vertical, 5)
                                            }
                                        }
                                        .frame(height: 200) // Adjust the height as needed
                                    }
                                }
                                
                                if showCustomUniversityField {
                                    TextField("Enter your university name", text: $viewModel.college)
                                        .padding()
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .onTapGesture {
                                            showList = false
                                        }
                                }
                                
                                HStack {
                                    Text("Year*")
                                        .foregroundColor(Color.blue)
                                        .font(.system(size: 15))
                                        .bold()
                                        .padding(.leading, 20)
                                    Spacer()
                                    
                                    VStack {
                                        Button(action: {
                                            isPopoverPresented.toggle()
                                        }) {
                                            Text("Select Year: \(viewModel.year)")
                                                .padding()
                                                .background(Capsule().fill(Color.yellow))
                                        }
                                        .popover(isPresented: $isPopoverPresented, arrowEdge: .bottom) {
                                            PopoverMenuView(options: academicYears) { selectedYear in
                                                viewModel.year = selectedYear
                                                isPopoverPresented = false
                                            }
                                            .frame(width: 150, height: 200) // Adjust the popover size as needed
                                            .padding()
                                        }
                                    }
                                }
                                
                                HStack {
                                    Text("Major*")
                                        .foregroundColor(Color.blue)
                                        .font(.system(size: 15))
                                        .bold()
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                                TextField("Computer Science", text: $viewModel.major)
                                    .padding(.horizontal,20)
                                    .frame(width: 250, height: 40)
                                    .background(Color.black.opacity(0.05))
                                    .cornerRadius(10)
                                    .padding(.bottom, 10)
                            }
                            
                            HStack(alignment: .top) {
                                Toggle("", isOn: $optIn)
                                    .toggleStyle(CheckboxToggle())
                                    .padding(.leading, 18)
                                    .offset(y:-2)
                                Text("Opt in to our mailing list for FREE productivity and study tips from a community of students all over the globe.")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color.blue)
                                    .padding(.top, 4)
                                    .padding(.leading, 2)
                            }
                            .padding(.bottom, 20)
                            
                            Text("By creating an account you accept our ")
                                .font(.footnote)
                                .foregroundColor(.gray) +
                            Text("Terms and Conditions")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .underline()
                            Button(action: {
                                viewModel.register()
                                navigate = true // Activate navigation after registration
                            }) {
                                ButtonView(text: "Create Account")
                            }
                            .background(
                                NavigationLink(destination: Onboarding10View(), isActive: $navigate) {
                                    EmptyView()
                                }
                                .hidden() // Hide the actual NavigationLink view
                            )

                            .padding(.top)
                           
                            
                            
                            HStack{
                                Text("Already a member?")
                                NavigationLink("Login", destination: LoginView())
                            }
                            
                        }.padding(.top, 10)
                        
                    }
                }
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 0) // This ensures the safe area on top
            }.onAppear{
                viewModel.firstName = userSettings.name
                viewModel.goals = userSettings.goals
                viewModel.unProdST = userSettings.unProdST
                viewModel.maxUnProdST = userSettings.maxUnProdST
            
        }
        
    }
    
    func filterUniversities() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            var filtered: [String]
            
            if searchText.isEmpty {
                filtered = universities
            } else {
                filtered = universities.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
            if !filtered.contains("Other") {
                filtered.append("Other")
            }
            DispatchQueue.main.async {
                filteredUniversities = filtered
                isLoading = false
                
                // Check if "Other" is in filteredUniversities and adjust showCustomUniversityField accordingly
                if searchText == "Other" {
                    showCustomUniversityField = true // Show custom university field if "Other" is present
                } else {
                    showCustomUniversityField = false // Hide custom university field if "Other" is not present
                }
            }
        }
    }

    func loadCSV() {
        if let filePath = Bundle.main.path(forResource: "world-universities", ofType: "csv") {
            do {
                let csvFile = try CSV<Named>(url: URL(fileURLWithPath: filePath))
                universities = csvFile.rows.compactMap { row in
                    if let code = row["code"], let name = row["name"] {
                        return "\(name), \(code)"
                    }
                    return nil
                }
                universities.append("Other")
                filteredUniversities = universities
            } catch {
                print("Error loading CSV: \(error)")
            }
        } else {
            print("CSV file not found.")
        }
    }
}

struct CheckboxToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? Color.blue : Color.gray)
                configuration.label
            }
        }
    }
}

// Helper function to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct PopoverMenuView: View {
    let options: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        onSelect(option)
                    }) {
                        Text(option)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(Color.yellow)
                            )
                            .padding(.horizontal, 10)
                    }
                    .padding()
                    .buttonStyle(PlainButtonStyle()) // Remove button default style
                }
            }
        }
    }
}
