//
//  PomodoroView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/16/24.
//

import SwiftUI

struct PomodoroView: View {
    @StateObject var viewModel = PomodoroViewViewModel()

    var body: some View {
        VStack{
            Text("hello")
                TotalActivityTabView()

                    }
    }
}

#Preview {
    PomodoroView()
}
