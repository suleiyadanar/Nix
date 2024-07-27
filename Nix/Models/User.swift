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
    let username: String
    let email: String
    let joined: TimeInterval
    let college: String
    let byear: String
    let year: String
    let major: String
    let opt: Bool
    let goals: Array<String>
    let unProdST: String
    let maxUnProdST : Int
}
