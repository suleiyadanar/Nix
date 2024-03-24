//
//  SettingsView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/15/24.
//
import SwiftUI

struct SettingsView: View {
    
    let lightBlue = Color(red: 0.8, green: 0.85, blue: 0.95)
    
    @State var editProfileView: Bool = false
    @State var securityView: Bool = false
    @State var notificationsView: Bool = false
    @State var privacyView: Bool = false
    
    @State var mySubscriptionView: Bool = false
    @State var helpAndSupportView: Bool = false
    @State var termsAndPoliciesView: Bool = false
    
    @State var freeUpSpaceView: Bool = false
    @State var dataSaverView: Bool = false
    
    @State var reportAProblemView: Bool = false
    @State var addAccountView: Bool = false
    @State var logOutView: Bool = false

    
    var body: some View {
        
        NavigationView {
            List {
                
                // section: account
                Section(header: Text("Account")) {
                    
                    Button {
                        self.editProfileView = true
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Edit Profile")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                    Button {
                        self.securityView = true
                    } label: {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Security")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                    Button {
                        self.notificationsView = true
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Notifications")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }    .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                    Button {
                        self.privacyView = true
                    } label: {
                        HStack {
                            Image(systemName: "lock.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Privacy")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                }
                .listRowBackground(lightBlue)
                
                // section: support
                Section(header: Text("Support & About")) {
                    Button {
                        self.mySubscriptionView = true
                    } label: {
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("My Subscription")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                    Button {
                        self.helpAndSupportView = true
                    } label: {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Help & Support")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                    Button {
                        self.termsAndPoliciesView = true
                    } label: {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Terms and Policies")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                }
                .listRowBackground(lightBlue)
                
                // section: cache
                Section(header: Text("Cache & Cellular")) {
                    Button {
                        self.freeUpSpaceView = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Free Up Space")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                    Button {
                        self.dataSaverView = true
                    } label: {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Data Saver")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                }
                .listRowBackground(lightBlue)
                
                // section: actions
                Section(header: Text("Actions")) {
                    Button {
                        self.reportAProblemView = true
                    } label: {
                        HStack {
                            Image(systemName: "flag.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Report a problem")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }   .listRowSeparator(.hidden)
                            .foregroundStyle(Color.black)
                    }
                    Button {
                        self.addAccountView = true
                    } label: {
                        HStack {
                            Image(systemName: "person.2.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Add account")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                    Button {
                        self.logOutView = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 20)
                            Text("Log out")
                            Spacer()
                            Image(systemName: "chevron.right")                        }
                    }   .listRowSeparator(.hidden)
                        .foregroundStyle(Color.black)
                }
                .listRowBackground(lightBlue)
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        
        .sheet(isPresented: $editProfileView) {
            EditProfileView()
        }
        .sheet(isPresented: $securityView) {
            SecurityView()
        }
        .sheet(isPresented: $notificationsView) {
            NotificationsView()
        }
        .sheet(isPresented: $privacyView) {
            PrivacyView()
        }
        .sheet(isPresented: $mySubscriptionView) {
            MySubscriptionView()
        }
        .sheet(isPresented: $helpAndSupportView) {
            HelpAndSupportView()
        }
        .sheet(isPresented: $termsAndPoliciesView) {
            TermsAndPolView()
        }
        .sheet(isPresented: $dataSaverView) {
            DataSaverView()
        }
        .sheet(isPresented: $reportAProblemView) {
            ReportAProblemView()
        }
        .sheet(isPresented: $addAccountView) {
            AddAccountView()
        }
        .sheet(isPresented: $logOutView) {
            LogOutView()
        }

        
    }
    
}
#Preview {
    SettingsView()
}

