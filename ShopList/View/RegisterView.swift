//
//  RegisterView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel: RegisterViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Register")
                    .font(.system(size: 32, weight: .heavy))
                    .accessibilityLabel("Register")

                VStack(spacing: 20) {
                    CustomTextField(text: $viewModel.email, error: $viewModel.emailError, placeholder: "Email", imageName: "envelope")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .accessibilityLabel("Email field")
                        .accessibilityValue(viewModel.email)

                    CustomTextField(text: $viewModel.username, error: $viewModel.usernameError, placeholder: "Username", imageName: "person")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .accessibilityLabel("Username field")
                        .accessibilityValue(viewModel.username)

                    CustomTextField(text: $viewModel.password, error: $viewModel.passwordError, placeholder: "Password", imageName: "lock", isPassword: true)
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .accessibilityLabel("Password field")

                    Button(action: {
                        viewModel.register()
                    }, label: {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .padding()
                    })
                    .accessibilityLabel("Register button")

                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Error"), message: Text(viewModel.errorString), dismissButton: .default(Text("OK")))
                    }
                }
                Spacer()

                Button(action: {
                    viewModel.showLoginView.toggle()
                }, label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 14))

                        Text("Sign In")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.bottom, 40)
                })
                .accessibilityLabel("Sign In button")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.userViewModel.showSettingsView = true
                    }) {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityLabel("Settings button")
                }
                
            }
            .sheet(isPresented: $viewModel.userViewModel.showSettingsView) {
                SettingsView(userViewModel: viewModel.userViewModel)
            }
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $viewModel.showLoginView) {
                LoginView(viewModel: LoginViewModel(userViewModel: viewModel.userViewModel))
            }
        }
    }
}
