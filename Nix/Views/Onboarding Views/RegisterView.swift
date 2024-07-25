import SwiftUI
import SwiftCSV


struct RegisterView: View {
    var props: Properties
    @Environment(\.colorScheme) var colorScheme

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
        ZStack {
            OnboardingBackgroundView()
            
            ScrollView {
                if universities.isEmpty {
                    Text("Loading...")
                        .onAppear {
                            loadCSV()
                        }
                } else {
                    VStack(spacing: 0) {
                        VStack(spacing: 20) {
                            Spacer()

                            HStack {
                                Text("Creating your account for you...")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                    .padding(.leading, props.isIPad ? 100 : 20)
                                    .padding(.trailing, props.isIPad ? 100 : 20)
                                Spacer()
                                Text(viewModel.errorMessage)
                                        .foregroundColor(.red)
                                        .padding(.top, 8)
                                
                            }

                            // Login Form
                            VStack {
                                VStack {
                                    HStack {
                                        Text("Username")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(.sky)
                                            .padding(.leading, props.isIPad ? 100 : 20)
                                            .padding(.trailing, props.isIPad ? 100 : 20)
                                        Spacer()
                                    }
                                    let rectangleWidth = CGFloat(props.width) * 0.8
                                    let rectangleHeight = props.isIPad ? CGFloat(60) : CGFloat(50)
                                    let cornerRadius = CGFloat(props.round.item)
                                    let fontSize = CGFloat(props.customFontSize.medium)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                        
                                    TextField("Username", text: $viewModel.username)
                                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                        .frame(width: rectangleWidth, height: rectangleHeight)
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .padding(.leading, props.isIPad ? 100 : 35)
                                        .padding(.trailing, props.isIPad ? 100 : 15)
                                        .onChange(of: viewModel.username) { newValue in
                                                if newValue.count > 20 {
                                                    viewModel.username = String(newValue.prefix(20))
                                                    viewModel.errorMessage = "Username cannot exceed 20 characters."
                                                } else if newValue.count < 6 {
                                                    viewModel.errorMessage = "Username must be at least 6 characters long."
                                                } else {
                                                    viewModel.errorMessage = "" // Clear the error message if the length is valid
                                                }
                                            }
                                    }
                                    Spacer()
                                    HStack {
                                        Text("Password")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(Color.sky)
                                            .padding(.leading, 20)
                                        Spacer()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                        
                                        SecureField("Strong Password", text: $viewModel.password)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            .autocapitalization(.none)
                                            .padding(.bottom, 10)
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 20)
                                    }
                                    Spacer()
                                    HStack {
                                        Text("School Email Address")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(Color.sky)
                                            .font(.system(size: 15))
                                            .padding(.leading, props.isIPad ? 100 : 20)
                                            .padding(.trailing, props.isIPad ? 100 : 20)
                                        Spacer()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                        
                                        TextField("Email", text: $viewModel.email)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                            .autocapitalization(.none)
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 20)
                                    }
                                    
//                                    HStack {
//                                        Text("College*")
//                                            .foregroundColor(Color.blue)
//                                            .font(.system(size: 15))
//                                            .bold()
//                                            .padding(.leading, 20)
//                                        Spacer()
//                                    }
//                                    
//                                    // Searchable university picker
//                                    TextField("Search for your university", text: $searchText)
//                                        .padding()
//                                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                                        .onChange(of: searchText, perform: { _ in
//                                            filterUniversities()
//                                        })
//                                        .onTapGesture {
//                                            showList = true
//                                        }
//                                    
//                                    if showList {
//                                        if isLoading {
//                                            ProgressView()
//                                        } else {
//                                            List {
//                                                ForEach(filteredUniversities, id: \.self) { university in
//                                                    Text(university)
//                                                        .onTapGesture {
//                                                            if university == "Other" {
//                                                                viewModel.college = "Other"
//                                                                searchText = university
//                                                                showList = false
//                                                                hideKeyboard()
//                                                                
//                                                                // Ensure showCustomUniversityField is shown
//                                                                showCustomUniversityField = true
//                                                            } else {
//                                                                viewModel.college = university
//                                                                searchText = university
//                                                                showList = false
//                                                                hideKeyboard()
//                                                                
//                                                                // Ensure showCustomUniversityField is hidden when other university is selected
//                                                                showCustomUniversityField = false
//                                                                customUniversityName = "" // Clear custom university name if previously set
//                                                            }
//                                                        }
//                                                        .padding(.vertical, 5)
//                                                }
//                                            }
//                                            .frame(height: 200) // Adjust the height as needed
//                                        }
//                                    }
//                                    
//                                    if showCustomUniversityField {
//                                        TextField("Enter your university name", text: $viewModel.college)
//                                            .padding()
//                                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                                            .onTapGesture {
//                                                showList = false
//                                            }
//                                    }
//                                    
                                    Spacer()
                                    HStack {
                                        Text("Year")
                                            .foregroundColor(Color.sky)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .font(.system(size: 15))
                                            .padding(.leading, props.isIPad ? 100 : 20)
                                        Spacer()
                                        
                                        VStack {
                                            Button(action: {
                                                isPopoverPresented.toggle()
                                            }) {
                                                Text("\(viewModel.year == "" ? academicYears[0] : viewModel.year)")
                                                    .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                                    .foregroundColor(Color.white)
                                                    .padding()
                                                    .background(Capsule().fill(Color.sky))
                                            }
                                            .popover(isPresented: $isPopoverPresented, arrowEdge: .bottom) {
                                                PopoverMenuView(options: academicYears) { selectedYear in
                                                    viewModel.year = selectedYear
                                                    isPopoverPresented = false
                                                }
                                                .frame(width: 150, height: 200) // Adjust the popover size as needed
                                                .padding()
                                            }
                                        }                                      .padding(.trailing, props.isIPad ? 100 : 20)

                                    }
                                    Spacer()
                                    HStack {
                                        Text("Major")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(Color.sky)
                                            .frame(height: 40)
                                            .font(.system(size: 15))
                                            .padding(.leading, props.isIPad ? 100 : 20)
                                            .padding(.trailing, props.isIPad ? 100 : 10)
                                        Spacer()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                        TextField("Computer Science", text: $viewModel.major)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                            .cornerRadius(10)
                                            .autocapitalization(.none)
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 20)
                                    }
                                }
                                Spacer()
                                HStack() {
                                    Toggle("", isOn: $optIn)
                                        .toggleStyle(CheckboxToggle())
                                        .padding(.leading, 18)
                                        .foregroundColor(Color.sky)
                                    Text("Opt in to our mailing list for FREE productivity and study tips from a community of students all over the globe.")
                                        .font(.custom("Montserrat-Regular", size: props.customFontSize.small))
                                        .foregroundColor(Color.sky)
                                        .padding(.top, 4)
                                        .padding(.leading, 2)
                                }
                                .padding(.bottom, 20)
                                
                                Text("By creating an account you accept our ")
                                    .font(.custom("Montserrat-Regular", size: props.customFontSize.small))
                                    .foregroundColor(Color.sky)                                    .foregroundColor(.gray) +
                                Text("Terms and Conditions")
                                    .font(.footnote)
                                    .foregroundColor(.sky)
                                    .underline()
                                Button(action: {
                                    viewModel.register()
                                    navigate = true // Activate navigation after registration
                                }) {
                                    ButtonView(props: props, text: "Register")
                                }
                                .background(
                                    NavigationLink(destination: Onboarding10View(props:props), isActive: $navigate) {
                                        EmptyView()
                                    }
                                        .hidden() // Hide the actual NavigationLink view
                                )
                                
                                .padding(.top)
                                
                                
                                
                                HStack{
                                    Text("Already a member?")
                                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    NavigationLink("Login", destination: LoginView(props: props))
                                        .font(.custom("Montserrat-Bold", size: props.customFontSize.smallMedium))
                                        .foregroundColor(Color.sky)
                                        .textCase(.uppercase)
                                }
                                
                            }.padding(.top, 10)
                            Spacer()
                        }
                    }
                    .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 1000)
                    .background(
                        RoundedRectangle(cornerRadius: props.round.sheet)
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                    )
                    .rotatingBorder()
                    
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
            .onTapGesture {
                hideKeyboard()
            }
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
                    .foregroundColor(configuration.isOn ? Color.babyBlue : Color.gray)
                    .frame(width:15, height: 15)
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
