import SwiftUI
import DeviceActivity
import FamilyControls

struct MainHomepageView: View {
    var props: Properties
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    @State private var authorizationError: Error?
    @State private var showAlert = false
    
    @State private var showSheet = false
    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewModel = HomepageViewViewModel()
    var streakCount: Int
    var progress: Double
    var userId: String
    
    @Binding var showTabBar: Bool
    
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total ScreenTime")
    
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
        during: Calendar.current.dateInterval(
        of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    
    @State private var contextRemaining: DeviceActivityReport.Context = .init(rawValue: "Remaining ScreenTime")
    
    @State private var filterRemaining = DeviceActivityFilter(
        segment: .daily(
        during: Calendar.current.dateInterval(
        of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    @State private var contextPercentage: DeviceActivityReport.Context = .init(rawValue: "Percent ScreenTime")
    
    @State private var filterPercentage = DeviceActivityFilter(
        segment: .daily(
        during: Calendar.current.dateInterval(
        of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )
    
    @State private var contextChartDay: DeviceActivityReport.Context = .init(rawValue: "ChartReportDay")
    @State private var today = Date() // Changed to @State

    private var filterChartDay: DeviceActivityFilter {
        return DeviceActivityFilter(
            segment: .hourly(
                during: Calendar.current.dateInterval(of: .day, for: today)!
            ),
            users: .all,
            devices: .init([.iPhone, .iPad])
        )
    }
    
    @State private var isExpanded: Bool = false

    
    var body: some View {
        let teamColor = userDefaults?.string(forKey: "team") ?? "water"
        NavigationStack {
            VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                ZStack {
                                    Image("calendar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: props.isIPad && !props.isSplit ? props.width * 0.08 : props.width * 0.1)
                                    Text("32")
                                        .padding(.top, 5)
                                        .foregroundColor(colorScheme == .dark ? .black : .black)
                                        .font(.custom("Montserrat-Bold", size: props.customFontSize.smallMedium))
                                }
                                
                                VStack {
                                    HStack {
//                                            Text("\(streakCount) days streak")
                                        Text(teamColor)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    HStack {
                                        ProgressBarPixel(props: props, progress: 3, color: Color.teamColor(for: teamColor, type: .secondary))
                                            .progressViewStyle(ThickProgressViewStyle(thickness: 10, color: .sky))
                                        Spacer()
                                    }
                                    .offset(y: -5)
                                }
                                
                                NavigationLink(destination: JourneyMapView(days: 3, unlockedDays: 1)
                                    .toolbarBackground(Color.clear, for: .navigationBar)
                                    .toolbarBackground(.hidden, for: .navigationBar)
                                    .onAppear {
                                        showTabBar = false
                                    }
                                    .onDisappear {
                                        showTabBar = true
                                    }
                                ) {
                                    Image("map")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: props.isIPad && !props.isSplit ? props.width * 0.04 :props.width * 0.05)
                                }.padding(.trailing,10)
                                Spacer()
                            }
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 15)
//                                .stroke(Color.sky, lineWidth: 1)
                            .fill(Color.teamColor(for: teamColor, type: .primary))
                            .padding(.horizontal, 10))
//            ScrollView{
            VStack {
                // Score box
                HStack {
                    Text("\(viewModel.greeting), \(viewModel.user?.firstName ?? "User")!")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .font(.custom("Montserrat-Regular", size: props.customFontSize.medium))
                        .padding(.leading, 20)
                    Spacer()
                }
                
                // Screen Time Box
                ScrollView{
                DeviceActivityReport(context, filter: filterChartDay)
                    .padding(.vertical, 10)
                    .frame(height: props.height * 0.45)
                
                    HStack {
                        Spacer()
                        Image("friend-list")
                            .padding(.trailing, 15)
                            .padding(.top, 10)
                    }
                    
                    Image("mascot-fox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:props.isIPad ? 300 : 150)
                        .padding()
                        .background(Color.clear)
                    
                    
                    // row of distracting apps icon, new freeze icon, and intentional mode icon
                    HStack {
                        HStack {
                            Image("distracting-apps")
                                .resizable()
                                .frame(width: 20, height: 20)
                            VStack {
                                HStack {
                                    Text("Distracting")
                                        .font(.footnote)
                                        .fixedSize(horizontal: true, vertical: false)
                                    Spacer()
                                }
                                HStack {
                                    Text("Apps")
                                        .font(.footnote)
                                        .fixedSize(horizontal: true, vertical: false)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.leading, 17)
                        
                        //                        Image("separating-line2")
                        //                            .resizable()
                        //                            .frame(width: 1, height: 40)
                        //                            .padding(.leading, 8)
                        //                            .padding(.trailing, 22)
                        
                        HStack {
                            Image("new-freeze")
                                .resizable()
                                .frame(width: 20, height: 20)
                            VStack {
                                HStack {
                                    Text("New")
                                        .font(.footnote)
                                    Spacer()
                                }
                                HStack {
                                    Text("Freeze")
                                        .font(.footnote)
                                    Spacer()
                                }
                            }
                            .padding(.leading, 2)
                        }
                        //                        Image("separating-line2")
                        //                            .resizable()
                        //                            .frame(width: 1, height: 40)
                        //                            .padding(.trailing, 8)
                        
                        HStack {
                            Image("intentional-mode")
                                .resizable()
                                .frame(width: 20, height: 20)
                            VStack {
                                HStack {
                                    Text("Intentional")
                                        .font(.footnote)
                                    Spacer()
                                }
                                HStack {
                                    Text("Mode")
                                        .font(.footnote)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.trailing, 7)
                    }
                    
                    
                }
            }
//            }
            QuickFreezeButton()
        }.onAppear {
            Task {
                do {
                    authorizationError = nil
                    showAlert = false
                    let center = AuthorizationCenter.shared
                    try await center.requestAuthorization(for: .individual)
                } catch{
                    authorizationError = error
                    showAlert = true // Show the alert on error
                }
            }
            viewModel.fetchUser()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("NotificationTapped"), object: nil, queue: .main) { _ in
                self.showSheet = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Authorization Error"),
                message: Text(authorizationError?.localizedDescription ?? "Nix requires access to Screen Time."),
                dismissButton: .default(Text("OK")) {
                    showAlert = false // Dismiss the alert
                }
            )
        }
        .sheet(isPresented: $showSheet) {
            TimeOutNotiView(isPresented: $showSheet)
        }
    }
}

struct ThickProgressViewStyle: ProgressViewStyle {
    var thickness: CGFloat
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: thickness)
            Rectangle()
                .fill(color)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 270, height: thickness)
        }
        .cornerRadius(thickness / 2)
    }
}

struct MoreButton: View {
    var body: some View {
        HStack {
            Text("More")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.mauve)
            Image(systemName: "arrow.right.circle")
                .foregroundColor(Color.mauve)
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 5)
        .background(Color.lemon)
        .cornerRadius(20)
    }
}

//struct MainHomepageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainHomepageView(streakCount: 5, progress: 0.75, userId: "Grace")
//    }
//}

struct QuickFreezeButton: View {
    var body: some View {
        ZStack {
            // Shadow layer
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lemon)
                .offset(x: 3, y: 5)
            
            // Button layer
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.lav.opacity(0.9))
                .strokeBorder(Color.mauve, lineWidth: 2)
            
            HStack {
                Text("Quick Freeze")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Image("snowflake")
            }
        }
        .frame(width: 250, height: 60)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
}


struct ProgressBarPixel: View {
    var props: Properties
    var progress: Int // Value 1,2,3
    var color: Color

    var body: some View {
        ZStack {
            // Background Rounded Rectangle
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.3)) // Change color as needed
                .frame(height: 30)

            // Foreground Rounded Rectangles
            HStack(spacing: 0) {
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 3)
                        .fill((index + 1) <= progress ? color : Color.commonGrey.opacity(0.5))
                        .frame(maxWidth: .infinity, maxHeight: 15) // Use maxWidth to evenly distribute
                        .padding(.horizontal, index == 1 ? 5 : 0) // Add spacing for the middle rectangle
                }
            }
            .padding(.horizontal, 5)
        }
    }
}
