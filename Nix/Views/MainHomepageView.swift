import SwiftUI

struct MainHomepageView: View {
    @StateObject var viewModel = HomepageViewViewModel()
    
    var streakCount: Int
    var progress: Double
    var userId: String
    
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
                    
                    Image("map")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.top, 70)
                .padding(.leading, 15)
                .padding(.trailing, 20)
                
                HStack {
                    //Text("Good Afternoon, \(userId)!") <-- use later
                    Text("Good Afternoon, Olive!")
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
                            HStack(alignment: .top) {
                                Text("1")
                                    .font(.system(size: 40))
                                    .fontWeight(.bold)
                                    .foregroundColor(.babyBlue)
                                Text("hr")
                                    .font(.system(size: 40))
                                    .fontWeight(.bold)
                                    .foregroundColor(.babyBlue)
                            }
                            HStack(alignment: .top) {
                                Text("23")
                                    .font(.system(size: 40))
                                    .fontWeight(.bold)
                                    .foregroundColor(.babyBlue)
                                Text("mins")
                                    .font(.system(size: 40))
                                    .fontWeight(.bold)
                                    .foregroundColor(.babyBlue)
                            }
                            
                            VStack {
                                Text("Remaining")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("32 mins")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .offset(x: -8)
                            }
                            
                        }
                        .offset(y: -5)
                            
                        Image("separating-line")
                            .padding(.leading, 20)
                            .padding(.trailing, 20)

                        VStack(alignment: .trailing) {
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 23))
                                .fontWeight(.regular)
                                .foregroundColor(.babyBlue)
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
                
                Image("lizard-nix")
                    .offset(y: -55)
                
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
                                Spacer()
                            }
                            HStack {
                                Text("Apps")
                                    .font(.footnote)
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, 15)
                    
                    Image("separating-line2")
                        .resizable()
                        .frame(width: 1, height: 40)
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                    
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
                }
                .offset(y:-70)
                
                QuickFreezeButton()
                    .offset(y:-60)
                
            }
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

struct MainHomepageView_Previews: PreviewProvider {
    static var previews: some View {
        MainHomepageView(streakCount: 5, progress: 0.75, userId: "Grace")
    }
}

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
