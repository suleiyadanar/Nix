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

    @State private var showView8 = false

    var body: some View {
        ScrollView{
            VStack {
                if showView8 {
                    Onboarding8View(props: props, showCurrView: $showView8)
                }else{
                    VStack(alignment: .center, spacing:0){
                        OnboardingProgressBarView(currentPage: 6)
                            .padding(.bottom, 25)
                        VStack(alignment: .leading, spacing:20){
                        
                        HStack {
                            Text("One more step: Connect us to your Screen Time!")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .font(.custom("Bungee-Regular", size: props.customFontSize.medium))
                                .padding(.leading, 20)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Your data is securely protected by Apple and only stays on your phone.")
                                .font(.custom("Montserrat-Regular", size: props.customFontSize.smallMedium))
                                .foregroundColor(.sky)
                                .padding(.bottom, 20)
                                .padding(.leading, 20)
                                .frame(maxWidth: .infinity, alignment: .center)

                            Spacer()
                        }
                            HStack{
                                Spacer()
                                NavigationLink(destination: Onboarding8View(props:props, showCurrView: $showView8), isActive: $isAuthorizationComplete) {
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
                                Spacer()

                            }
                    }
                       
                } .frame(width: props.width * 0.9, height: props.isIPad ? 1000 : 750)
                        .background(
                            RoundedRectangle(cornerRadius: props.round.sheet)
                                .fill(colorScheme == .dark ? Color.black : Color.white)
                        )
                        .rotatingBorder()
            }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
          
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

