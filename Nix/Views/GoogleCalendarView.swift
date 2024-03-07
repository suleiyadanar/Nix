//
//  GoogleCalendarView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/23/24.
//

import SwiftUI

struct GoogleCalendarView: View {
    @StateObject var viewModel = GoogleCalendarViewViewModel()

    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button {
                viewModel.googleSignInBtnPressed()
            }label:{
                Text("Import")
            }
        }
        
    }
}

#Preview {
    GoogleCalendarView()
}
