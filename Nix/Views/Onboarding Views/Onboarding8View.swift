import SwiftUI

struct Onboarding8View: View {
    @State private var progress: Double = 0.0
    @State private var navigate: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Creating your personalized \nroad map ...")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .padding(.bottom, 17)
                        .padding(.leading, 38)
                        .padding(.top, 190)
                    Spacer()
                }
                
                ProgressBar(progress: $progress)
                    .frame(width: 300, height: 20)
                    .onAppear {
                        startProgress()
                    }
                Spacer()
            }
            .navigationDestination(isPresented: $navigate) {
                Onboarding9View()
            }
        }
        .onChange(of: progress) { oldProgress, newProgress in
            if newProgress >= 1.0 {
                navigate = true
            }
        }
        .navigationBarHidden(true)
    }
    
    func startProgress() {
        let duration: Double = 4.0
        let interval: Double = 0.1
        let steps: Double = duration / interval
        let increment: Double = 1.0 / steps
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if progress < 1.0 {
                progress += increment
            } else {
                timer.invalidate()
            }
        }
    }
}

struct ProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 20)
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: .gray, radius: 7, x: 0, y: 2)
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                       gradient: Gradient(colors: [Color.babyBlue, Color.lemon]),
                       startPoint: .leading,
                       endPoint: .trailing
                       ))
                .frame(width: CGFloat(progress) * 300, height: 20)
                .animation(.linear(duration: 0.1), value: progress)
        }
    }
}

