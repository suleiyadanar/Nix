import SwiftUI
import FamilyControls

struct Onboarding7View: View {
    var props: Properties
    @Binding var showCurrView: Bool // Use a Binding to manage the view transition state
    @Environment(\.colorScheme) var colorScheme

    let center = AuthorizationCenter.shared
    @State private var authorizationError: Error?
    @State private var isAuthorizationComplete = false
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .center, spacing: 0) {
                        OnboardingProgressBarView(currentPage: 6)
                            .padding(.bottom, 25)
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("One more step: Connect us to your Screen Time!")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                    .padding(.leading, props.isIPad ? 100 : 20)
                                    .padding(.trailing, props.isIPad ? 100 : 10)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Image("sTDialog")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: props.width * 0.3)
                                    .cornerRadius(props.round.sheet)
                                    .rotatingBorder(props: props)
                                    .onTapGesture {
                                        attemptAuthorization()
                                    }
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Your data is securely protected by Apple and only stays on your phone.")
                                    .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                    .foregroundColor(.sky)
                                    .padding(.leading, props.isIPad ? 100 : 20)
                                    .padding(.trailing, props.isIPad ? 100 : 10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    attemptAuthorization()
                                }) {
                                    ButtonView(props: props, text: "Connect")
                                }
                                Spacer()
                            }
                        }
                    }
                    .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 750)
                    .background(
                        RoundedRectangle(cornerRadius: props.round.sheet)
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                    )
                    .rotatingBorder(props: props)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer(minLength: 20)
            }
            .scrollDisabled(true)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 100 { // Adjust the threshold as needed
                            showCurrView = false
                        }
                    }
            )
            .navigationDestination(isPresented: $isAuthorizationComplete) {
                Onboarding8View(props: props, showCurrView: $showCurrView)
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
    }

    private func attemptAuthorization() {
        Task {
            do {
                // Reset error state before attempting authorization
                authorizationError = nil
                showAlert = false
                try await center.requestAuthorization(for: .individual)
                // If successful, navigate to the next screen
                isAuthorizationComplete = true
            } catch {
                authorizationError = error
                showAlert = true // Show the alert on error
            }
        }
    }
}
