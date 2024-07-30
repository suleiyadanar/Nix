//
//  Colors.swift
//  Nix
//
//  Created by Grace Yang on 6/2/24.
//

import Foundation
import SwiftUI

extension Color {
    static let lavender = Color(red: 0.8, green: 0.85, blue: 0.95)
    static let indigo = Color(red: 0.4, green: 0.4, blue: 0.6)
    static let lightYellow = Color(red: 1.0, green: 1.0, blue: 0.8)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)

    // Custom Colors
    static let lav = Color(red: 0.812, green: 0.643, blue: 0.8)
    static let poppy = Color(red: 0.933, green: 0.353, blue: 0.212)
    static let babyBlue = Color(red: 0.624, green: 0.769, blue: 0.91)
    static let forest = Color(red: 0.102, green: 0.584, blue: 0.384)
    static let mango = Color(red: 0.961, green: 0.671, blue: 0.329)
    static let sky = Color(red: 0.373, green: 0.565, blue: 0.702)
    static let apricot = Color(red: 1.0, green: 0.471, blue: 0.275)
    static let mauve = Color(red: 0.592, green: 0.451, blue: 0.494)
    static let bubble = Color(red: 0.902, green: 0.494, blue: 0.494)
    static let lemon = Color(red: 0.984, green: 0.843, blue: 0.314)
    
    static let water_primary = Color(red: 0.624, green: 0.769, blue: 0.91)
    static let water_secondary = Color(red: 0.373, green: 0.565, blue: 0.702)
    static let water_accent = Color(red: 179/255, green: 152/255, blue:190/255)
    static let water_fourth = Color(red: 225/255, green: 238/255, blue:246/255)

    static let fire_primary = Color(red: 251/255, green: 194/255, blue:111/255)
    static let fire_secondary = Color(red: 233/255, green: 141/255, blue:121/255)
    static let fire_accent = Color(red: 159/255, green: 141/255, blue: 161/255)
    static let fire_fourth = Color(red: 250/255, green: 238/255, blue: 220/255)
    
    static let earth_primary = Color(red: 164/255, green: 193/255, blue: 180/255)
    static let earth_secondary = Color(red: 184/255, green: 151/255, blue: 139/255)
    static let earth_accent = Color(red: 200/255, green: 164/255, blue: 185/255)
    static let earth_fourth = Color(red: 232/255, green: 238/255, blue: 235/255)
    
    static let air_primary = Color(red: 225/255, green: 218/255, blue: 218/255)
    static let air_secondary = Color(red: 179/255, green: 195/255, blue: 191/255)
    static let air_accent = Color(red: 244/255, green: 231/255, blue: 127/255)
    static let air_fourth = Color(red: 244/255, green: 243/255, blue: 242/255)
    
    static let commonGrey = Color(red: 237/255, green: 237/255, blue: 236/255)

    enum TeamColorType {
          case primary
          case secondary
          case accent
          case fourth
    }
    
    static func teamColor(for team: String?, type: TeamColorType) -> Color {
            switch (team, type) {
            case ("water", .primary):
                return .water_primary
            case ("water", .secondary):
                return .water_secondary
            case ("water", .accent):
                return .water_accent
            case ("water", .fourth):
                return .water_fourth

            case ("fire", .primary):
                return .fire_primary
            case ("fire", .secondary):
                return .fire_secondary
            case ("fire", .accent):
                return .fire_accent
            case ("fire", .fourth):
                return .fire_fourth

            case ("earth", .primary):
                return .earth_primary
            case ("earth", .secondary):
                return .earth_secondary
            case ("earth", .accent):
                return .earth_accent
            case ("earth", .fourth):
                return .earth_fourth

            case ("air", .primary):
                return .air_primary
            case ("air", .secondary):
                return .air_secondary
            case ("air", .accent):
                return .air_accent
            case ("air", .fourth):
                return .air_fourth

            default:
                return .gray // Fallback color if the team or type is not recognized
            }
        }
    
}
