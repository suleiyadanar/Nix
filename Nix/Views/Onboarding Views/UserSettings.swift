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
    @Published var unProdST: String = ""
    @Published var maxUnProdST: Int = 0
    @Published var ready: Bool = false
}


