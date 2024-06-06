//
//  NixApp.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/15/24.
//

import SwiftUI
import FirebaseCore
import FamilyControls
import DeviceActivity


private let thisWeek = DateInterval(start: Date(), end: Date())

@main

struct NixApp: App {
    
    var userSettings = UserSettings()
    
    init() {
        FirebaseApp.configure()
    }
    let center = AuthorizationCenter.shared

    var body: some Scene {
        WindowGroup {

            MainView()
                .onAppear {
                    Task {
                        do {
                            try await center.requestAuthorization(for: .individual)
                        } catch {
                            print("Error")
                        }
                    }
                }
                .environment(\.colorScheme, .light)
                // sorry we can change this after i figure out how to change the placeholder text color for the
                // text input boxes bc it keeps changing when its light/dark mode and becoming invisible in dark mode
                .environmentObject(userSettings)
        }
    }
}
