//
//  NixApp.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/15/24.
//

import SwiftUI
import FirebaseCore
import FamilyControls

@main
struct NixApp: App {
    init() {
        FirebaseApp.configure()
    }
    let center = AuthorizationCenter.shared

    var body: some Scene {
        WindowGroup {
            MainView()
//                .onAppear {
//                    Task {
//                        do {
//                            try await center.requestAuthorization(for: .individual)
//                        } catch {
//                            print("Error")
//                        }
//                    }
//                }
        }
    }
}
