//
//  GoogleCalendarViewViewModel.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/23/24.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcherCore
import SafariServices

class GoogleCalendarViewViewModel: ObservableObject {
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    var viewModel = ViewController()

    
//    func googleSignInBtnPressed() {
//        
//    }
    
    @IBAction func googleSignInBtnPressed() {
        GIDSignIn.sharedInstance().clientID = "619760553436-cvr4rum3g66l7knjji81n76n1rag8i0b.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().presentingViewController = UINavigationController(rootViewController: viewModel)
    }

    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) -> GIDSignInDelegate {
//        if let error = error {
//                    showAlert(title: "Authentication Error", message: error.localizedDescription)
//                    self.service.authorizer = nil
//                } else {
//                    self.service.authorizer = user.authentication.fetcherAuthorizer()
//                }
//    }
    // Helper for showing an alert
        func showAlert(title : String, message: String) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            let ok = UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            )
            alert.addAction(ok)
//            present(alert, animated: true, completion: nil)
        }
}


    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
//            showAlert(title: "Authentication Error", message: error.localizedDescription)
//            self.service.authorizer = nil
//        } else {
//            self.service.authorizer = user.authentication.fetcherAuthorizer()
//        }

