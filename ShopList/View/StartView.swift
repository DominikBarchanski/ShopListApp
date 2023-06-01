//
//  StartView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import SwiftUI
enum ActiveSheet: Identifiable {
    case login, register

    

    var id: Int {
        hashValue
    }
}

struct StartView: View {
    @StateObject var viewModel: UserViewModel
    @State private var activeSheet: ActiveSheet?

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                CustomText("Welcome to ShopList")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .accessibilityLabel("Welcome to ShopList")

                Button(action: {
                    viewModel.showLoginView = true
                }, label: {
                    CustomText("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                })
                .accessibilityLabel("Log In button")
                .accessibilityHint("Tap to log in to your account")

                Button(action: {
                    viewModel.showRegisterView = true
                }, label: {
                    CustomText("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                })
                .accessibilityLabel("Sign Up button")
                .accessibilityHint("Tap to sign up for a new account")

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showSettingsView = true
                    }) {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $viewModel.showSettingsView) {
                SettingsView(userViewModel: viewModel)
            }
            .fullScreenCover(item: $activeSheet) { item in
                switch item {
                case .login:
                    LoginView(viewModel: LoginViewModel(userViewModel: viewModel))
                case .register:
                    RegisterView(viewModel: RegisterViewModel(userViewModel: viewModel))
                }
            }
            .onReceive(viewModel.$showLoginView) { show in
                activeSheet = show ? .login : nil
            }
            .onReceive(viewModel.$showRegisterView) { show in
                activeSheet = show ? .register : nil
            }
        }
    }
}
