import SwiftUI
import DeviceActivity

struct MainHomepageView: View {
    var props: Properties

    @State private var showSheet = false

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
    

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image("medal")
                        .resizable()
                        .frame(width: 24, height: 24)
                    VStack {
                        HStack {
                            Text("\(streakCount) days streak")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        HStack {
                            ProgressView(value: progress, total: 1.0)
                                .progressViewStyle(ThickProgressViewStyle(thickness: 10, color: .sky))
                            Spacer()
                        }
                        .offset(y: -5)
                    }
                    .padding(.leading, 5)
                    Spacer()
                    NavigationLink(destination: JourneyMapView(days:3, unlockedDays: 1)
                        .toolbarBackground(Color.clear, for: .navigationBar)
                        .toolbarBackground(.hidden, for: .navigationBar)
                        .onAppear{
                            showTabBar = false
                          

                        }.onDisappear{
                            showTabBar = true
                        }
                    
                    ) {
                        Image("map")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                        
                }
                .padding(.top, 70)
                .padding(.leading, 15)
                .padding(.trailing, 20)
                
                HStack {
                    //Text("Good Afternoon, \(userId)!") <-- use later
                    Text("\(viewModel.greeting), \(viewModel.user?.firstName ?? "User")!")
                        .font(.system(size: 29))
                        .padding(.leading, 20)
                        .fontWeight(.light)
                    Spacer()
                }
                
                // Screen Time Box
                VStack(alignment: .leading) {
                    HStack {
                        Text("Today's Screen Time")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        Spacer()
                        
                    }
                    HStack(alignment: .top) {
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            DeviceActivityReport(context, filter:
                                                    filter)
                            .frame(width: props.width * 0.3, height: props.height * 0.1)
                            DeviceActivityReport(contextRemaining, filter:
                                                    filterRemaining)
                            .frame(width: props.width * 0.3, height: props.height * 0.1)
                            
                        }
                        .offset(y: -5)
                            
                        Image("separating-line")
                            .padding(.leading, 20)
                            .padding(.trailing, 20)

                        VStack(alignment: .trailing) {
                            DeviceActivityReport(contextPercentage, filter:
                                                    filterPercentage)
                            .frame(width: props.width * 0.2, height: props.height * 0.05)
                            Text("Screen Time Used")
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                                .foregroundColor(.black)
                            NavigationLink(destination: ScreenTimeView()) {
                                MoreButton()
                                    .padding(.top, 45)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.sky, lineWidth: 1)
                    .padding(.leading, 10)
                    .padding(.trailing, 10))

                HStack {
                    Spacer()
                    Image("friend-list")
                        .padding(.trailing, 15)
                        .padding(.top, 10)
                }
                
                Image("mascot-fox")
                    .resizable()
                    .offset(y: -55)
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
                    
                    Image("separating-line2")
                        .resizable()
                        .frame(width: 1, height: 40)
                        .padding(.leading, 8)
                        .padding(.trailing, 22)
                    
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
                    Image("separating-line2")
                        .resizable()
                        .frame(width: 1, height: 40)
                        .padding(.trailing, 8)
                    
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
                .offset(y:-70)
                
                QuickFreezeButton()
                    .offset(y:-60)
                
            }
        }.onAppear {
            viewModel.fetchUser()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("NotificationTapped"), object: nil, queue: .main) { _ in
                self.showSheet = true
            }
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
