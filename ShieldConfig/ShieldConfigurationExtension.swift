//
//  ShieldConfigurationExtension.swift
//  ShieldConfig
//
//  Created by Su Lei Yadanar on 6/1/24.
//

import ManagedSettings
import ManagedSettingsUI
import DeviceActivity

import UIKit
import SwiftUI

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    let userDefaults = UserDefaults(suiteName: "group.com.nix.Nix")

    override func configuration(shielding application: Application) -> ShieldConfiguration {

        // Customize the shield as needed for applications.
        let mode = userDefaults?.string(forKey: "mode")
        print("\(mode)")
        if (mode == "intentional"){
            print("got here")
            return ShieldConfiguration(
                backgroundColor: UIColor.blue,
                icon: UIImage(named:"lizard-nix"),
                title:ShieldConfiguration.Label(text:"NIX", color: UIColor.purple),
                primaryButtonLabel: ShieldConfiguration.Label(text:"OK", color:UIColor.green),
                secondaryButtonLabel: ShieldConfiguration.Label(text:"Keep Using", color:UIColor.orange)
                )
        }
        return ShieldConfiguration(
            backgroundColor: UIColor.blue,
            icon: UIImage(named:"lizard-nix"),
            title:ShieldConfiguration.Label(text:"NIX", color: UIColor.purple),
            primaryButtonLabel: ShieldConfiguration.Label(text:"OK", color:UIColor.green),
            secondaryButtonLabel: ShieldConfiguration.Label(text:"Unblock Apps", color:UIColor.orange)
            )
        
    }
    
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
