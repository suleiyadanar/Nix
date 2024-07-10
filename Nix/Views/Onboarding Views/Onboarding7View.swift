import SwiftUI
import FamilyControls

struct Onboarding7View: View {
    var props: Properties

    let center = AuthorizationCenter.shared
    @State private var authorizationError: Error?
    @State private var isAuthorizationComplete = false
    @State private var showAlert = false

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            VStack {
                OnboardingProgressBarView(currentPage: 6)
                    .padding(.bottom, 25)
                HStack {
                    Text("One more step: Connect us to your Screen Time!")
                        .foregroundColor(.black)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
                HStack {
                    Text("Your data is securely protected by Apple and only stays on your phone.")
                        .font(.system(size: 15))
                        .foregroundColor(.blue) // Use your custom color here
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                NavigationLink(destination: Onboarding8View(props:props), isActive: $isAuthorizationComplete) {
                    ButtonView(props: props, text: "Connect")
                        .onTapGesture {
                            attemptAuthorization()
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
            }
            .padding(.bottom, 60)
        }
        .navigationBarHidden(true)
    }

    private func attemptAuthorization() {
        Task {
            do {
                // Reset error state before attempting authorization
                authorizationError = nil
                showAlert = false
                try await center.requestAuthorization(for: .individual)
                // If successful, navigate to next screen
                isAuthorizationComplete = true
            } catch {
                authorizationError = error
                showAlert = true // Show the alert on error
            }
        }
    }
}

//struct Onboarding7View_Previews: PreviewProvider {
//    static var previews: some View {
//        Onboarding7View()
//    }
//}

