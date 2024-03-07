//
//  ViewControllerRepresentableView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/22/24.
//

import SwiftUI

struct ViewControllerRepresentableView: UIViewControllerRepresentable {
    // this is the binding that is received from the SwiftUI side
    let identifier: Binding<[CalendarEvent]>
    
    // this will be the delegate of the view controller, it's role is to allow
       // the data transfer from UIKit to SwiftUI
       class Coordinator: ViewControllerDelegate {
           let identifierBinding: Binding<[CalendarEvent]>
           
           init(identifierBinding: Binding<[CalendarEvent]>) {
               self.identifierBinding = identifierBinding
           }
           
           func clasificationOccured(_ viewController: ViewController, identifier: [CalendarEvent]) {
               // whenever the view controller notifies it's delegate about receiving a new idenfifier
               // the line below will propagate the change up to SwiftUI
               identifierBinding.wrappedValue = identifier
           }
       }
    
    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        vc.delegate = context.coordinator

        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
    // this is very important, this coordinator will be used in `makeUIViewController`
    func makeCoordinator() -> Coordinator {
        Coordinator(identifierBinding: identifier)
    }
}

//#Preview {
//    CalendarRowView(identifier: "")
//}
