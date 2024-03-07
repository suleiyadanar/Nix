//
//  Users.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import Foundation

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let joined: TimeInterval
}
