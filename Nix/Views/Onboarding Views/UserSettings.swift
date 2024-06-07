//
//  UserSettings.swift
//  Nix
//
//  Created by Grace Yang on 6/3/24.
//

import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var name: String = ""
    @Published var goals: [String] = []
}

