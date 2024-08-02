import SwiftUI
import SwiftCSV

struct CustomPopupViewText: View {
    var props: Properties
    @Environment(\.colorScheme) var colorScheme

    var items: [String]
    var columns: Int
    var onSelect: (String) -> Void
    @Binding var isVisible: Bool
    var selectedItem: String? // Add this property

    var body: some View {
        VStack {
            if isVisible {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: columns), spacing: 10) {
                            ForEach(items, id: \.self) { item in
                                Button(action: {
                                    onSelect(item)
                                }) {
                                    Text(item)
                                        .font(.custom("Montserrat-Bold]", size: props.customFontSize.smallMedium))
                                        .padding()
                                        .background(
                                            Capsule()
                                                .fill(item == selectedItem ? Color.sky : Color.white)
                                                .frame(width:150)
                                                .overlay(
                                                    Capsule()
                                                        .stroke(item == selectedItem ? Color.sky : Color.clear, lineWidth: 2)
                                                    )
                                        ) // Highlight selected item
                                        .foregroundColor(item == selectedItem ? Color.white : Color.black)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(width: props.width * 0.4, height: props.height * 0.4)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(20)
                }
                .position(x: props.width / 2, y: props.height / 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                .onTapGesture {
                    isVisible = false
                }
            }
        }
    }
}


struct RegisterView: View {
    var props: Properties
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var userSettings: UserSettings

    @StateObject var viewModel = RegisterViewViewModel()
    @State private var optIn: Bool = false
    @State private var navigate: Bool = false
    @State private var isPopoverPresented: Bool = false
    let academicYears = ["Pre-college","Freshman", "Sophomore", "Junior", "Senior", "Associate", "Master's", "PhD", "PostDoc"]

    @State private var universities: [String] = []
    @State private var searchText: String = ""
    @State private var showList: Bool = false
    @State private var isLoading: Bool = false
    @State private var filteredUniversities: [String] = []
    @State private var showCustomUniversityField: Bool = false
    @State private var customUniversityName: String = ""
    
    @State private var selectedDate = Date() // Track selected date
    @State private var showTermsAndConditions = false
    
    @State private var showYearsPopup = false
    @State private var showBdayPopup = false

    private var birthYears: [String] {
        let currentYear = Calendar.current.component(.year, from: Date())
        let startYear = currentYear - 25
        let endYear = currentYear - 18

        var yearsArray: [String] = []
        yearsArray.append("≥\(endYear+1)")


        for year in stride(from: endYear, through: startYear, by: -1) {
            yearsArray.append(String(year))
        }
        
        yearsArray.append("≤\(startYear-1)")

        return yearsArray
    }

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

                            VStack {
                                Text("Creating your account for you...")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                    .padding(.leading, props.isIPad ? 100 : 20)
                                    .padding(.trailing, props.isIPad ? 100 : 20)
                                if (viewModel.errorMessage != "" ){
                                    Text(viewModel.errorMessage)
                                            .foregroundColor(.red)
                                            .padding(.top, 8)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                }
                           
                            }

                            let rectangleWidth = props.isIPad ? CGFloat(props.width) * 0.6 : CGFloat(props.width) * 0.7
                            let rectangleHeight = props.isIPad ? CGFloat(60) : CGFloat(50)
                            let cornerRadius = CGFloat(props.round.item)
                            let fontSize = CGFloat(props.customFontSize.medium)
                            // Login Form
                            VStack {
                                VStack {
                                    HStack {
                                        Text("Username")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(.sky)
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 35)
                                        Spacer()
                                    }
                                   
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                           
                                        
                                    TextField("Username", text: $viewModel.username)
                                        .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .frame(width: rectangleWidth, height: rectangleHeight)
                                        .autocapitalization(.none)
                                        .padding(.horizontal, props.isIPad ? 30 : 15)
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
                                    .frame(width: rectangleWidth, height: rectangleHeight)
                                    .padding(.leading, props.isIPad ? 100 : 35)
                                    .padding(.trailing, props.isIPad ? 100 : 35)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("Password")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(Color.sky)
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 35)
                                        Spacer()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                            
                                        
                                        SecureField("Strong Password", text: $viewModel.password)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            .autocapitalization(.none)
                                            .padding(.horizontal, props.isIPad ? 30 : 15)
                                            
                                    }.frame(width: rectangleWidth, height: rectangleHeight)
                                        .padding(.leading, props.isIPad ? 100 : 35)
                                        .padding(.trailing, props.isIPad ? 100 : 35)
                                    Spacer()
                                    HStack {
                                        Text("School Email Address")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(Color.sky)
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 35)
                                        Spacer()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                          
                                        
                                        TextField("Email", text: $viewModel.email)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                            .autocapitalization(.none)
                                            .padding(.horizontal, props.isIPad ? 30 : 15)
                                    }.frame(width: rectangleWidth, height: rectangleHeight)
                                        .padding(.leading, props.isIPad ? 100 : 35)
                                        .padding(.trailing, props.isIPad ? 100 : 35)
                                    
                                    Spacer()
                                    HStack {
                                        Text("Birth Year")
                                            .foregroundColor(Color.sky)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .font(.system(size: 15))
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 35)
                                        Spacer()
                                        
                                        VStack {
                                            Button(action: {
                                                showBdayPopup.toggle()
                                            }) {
                                                Text("\(viewModel.byear == "" ? birthYears[1] : viewModel.byear)")
                                                    .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                                    .foregroundColor(Color.white)
                                                    .padding()
                                                    .background(Capsule().fill(Color.sky))
                                            }
                                        
                                        }.padding(.trailing, props.isIPad ? 80 : 20)

                                    }.onAppear{
                                        viewModel.byear = birthYears[1]
                                    }
                                    
                                    Spacer()
                                    HStack {
                                        Text("Year")
                                            .foregroundColor(Color.sky)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 35)
                                        Spacer()
                                        
                                        VStack {
                                            Button(action: {
                                                showYearsPopup.toggle()
                                            }) {
                                                Text("\(viewModel.year == "" ? academicYears[1] : viewModel.year)")
                                                    .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                                    .foregroundColor(Color.white)
                                                    .padding()
                                                    .background(Capsule().fill(Color.sky))
                                            }
                                        } .padding(.trailing, props.isIPad ? 80 : 20)

                                    }.onAppear{
                                        viewModel.year = academicYears[1]
                                    }
                                    Spacer()
                                    HStack {
                                        Text("Major")
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(Color.sky)
                                            .padding(.leading, props.isIPad ? 100 : 35)
                                            .padding(.trailing, props.isIPad ? 100 : 35)
                                        Spacer()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.2) :  Color.black.opacity(0.06))
                                           
                                        TextField("Computer Science", text: $viewModel.major)
                                            .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                            .frame(width: rectangleWidth, height: rectangleHeight)
                                            .cornerRadius(10)
                                            .padding(.horizontal, props.isIPad ? 30 : 15)
                                            .autocapitalization(.none)
                                            
                                    }.frame(width: rectangleWidth, height: rectangleHeight)
                                        .padding(.leading, props.isIPad ? 100 : 35)
                                        .padding(.trailing, props.isIPad ? 100 : 35)
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
                                }.padding(.leading, props.isIPad ? 100 : 35)
                                .padding(.trailing, props.isIPad ? 100 : 15)
                                .padding(.vertical, 20)
                                
                                VStack {
                                            Text("By creating an account you accept our")
                                                .font(.custom("Montserrat-Regular", size: props.customFontSize.small))
                                                .foregroundColor(.sky)
                                                .multilineTextAlignment(.center)
                                                Text("Terms and Conditions")
                                                .font(.custom("Montserrat-Regular", size: props.customFontSize.small))
                                                .foregroundColor(.sky)
                                                .underline()
                                                .multilineTextAlignment(.center)
                                                .onTapGesture {
                                                    showTermsAndConditions = true
                                                }
                                        }
                                .sheet(isPresented: $showTermsAndConditions) {
                                    // Your Terms and Conditions view
                                    EmptyView()
                                }
                                Button(action: {
                                    viewModel.register()
                                    if viewModel.errorMessage == "" {
                                        navigate = true // Activate navigation after registration
                                    }
                                 
                                }) {
                                    ButtonView(props: props, text: "Register", imageName: nil)
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
                    .rotatingBorder(props: props)
                    
                }
                
            }
            .scrollIndicators(.hidden)
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
            if showBdayPopup {
                CustomPopupViewText(
                    props: props,
                    items: birthYears,
                    columns: 1,
                    onSelect: { value in
                        viewModel.byear = value
                        showBdayPopup = false
                    },
                    isVisible: $showBdayPopup,
                    selectedItem: viewModel.byear // Pass the current selected birth year
                ).onAppear{
                    print("bday pop up: \(viewModel.byear)")
                }
            }


            if showYearsPopup {
               
                CustomPopupViewText(
                    props: props,
                    items: academicYears,
                    columns: 1,
                    onSelect: { value in
                        viewModel.year = value
                        showYearsPopup = false
                    },
                    isVisible: $showYearsPopup,
                    selectedItem: viewModel.year // Pass the current selected academic year
                ).onAppear{
                    print("bday pop up: \(viewModel.year)")
                }
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
