//
//  ViewControllerRepresentableView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/22/24.
//

import SwiftUI

struct ViewControllerRepresentableView: UIViewControllerRepresentable {
    let identifier: Binding<[CalendarEvent]>
    let startDateTime: Date
    let endDateTime:  Date

    class Coordinator: ViewControllerDelegate {
        let identifierBinding: Binding<[CalendarEvent]>

        init(identifierBinding: Binding<[CalendarEvent]>) {
            self.identifierBinding = identifierBinding
        }

        func clasificationOccured(_ viewController: ViewController, identifier: [CalendarEvent]) {
            identifierBinding.wrappedValue = identifier
        }
    }

    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        vc.delegate = context.coordinator
        vc.startDateTime = startDateTime
        vc.endDateTime = endDateTime
        return vc
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        uiViewController.startDateTime = startDateTime
        uiViewController.endDateTime = endDateTime
        uiViewController.getEvents(for: "primary")
        print("Updating ViewController with startDateTime: \(startDateTime), endDateTime: \(endDateTime)")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(identifierBinding: identifier)
    }
}


//#Preview {
//    CalendarRowView(identifier: "")
//}
