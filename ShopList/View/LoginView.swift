//
//  LoginView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import SwiftUI
import KeychainSwift

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                CustomText("ShopList")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .accessibilityLabel("ShopList")

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
                
                if(viewModel.showAlert){
                    CustomText(viewModel.errorString)
                        .foregroundColor(.red)
                }
                Button(action: {
                    viewModel.login()
                }, label: {
                    CustomText("Sign In")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .padding()
                .accessibilityLabel("Sign In button")

                if viewModel.userViewModel.settings.isTokenSaved {
                    CustomText("or")

                    Button(action: {
                        viewModel.login()
                    }, label: {
                        CustomText("Login through Token")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    .accessibilityLabel("Login through Token button")
                }

                Spacer()

                Button(action: {
                    viewModel.showLoginView = false
                    viewModel.userViewModel.showRegisterView = false
                }, label: {
                    HStack {
                        CustomText("Back to main screen")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(.black)
                    .padding(.bottom, 40)
                })
                .accessibilityLabel("Back to main screen button")
            }
            .onAppear {
                if viewModel.userViewModel.settings.keepLogin {
                    let keychain = KeychainSwift()

                    if let token = keychain.get("bearerToken"), !token.isEmpty {
                        viewModel.login()
                    }
                }
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
                StartView(viewModel: viewModel.userViewModel)
            }
        }
    }
}
