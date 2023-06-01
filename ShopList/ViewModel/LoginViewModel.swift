//
//  LoginViewModel.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import Combine
class LoginViewModel: ObservableObject{
    
    
    @Published var userViewModel: UserViewModel
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var errorString = ""
    @Published var showLoginView = false
    @Published var usernameError = ""
    @Published var passwordError = ""
    private var isError = false
    private var cancellables: Set<AnyCancellable> = []
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel

    }

    func login() {
        usernameError = ""
        passwordError = ""
        isError = false
        if !userViewModel.settings.isTokenSaved{
            if username.isEmpty{
                usernameError = "User name is required"
                isError = true
                
            }
            if password.isEmpty{
                passwordError = "Password is required"
                isError = true
            }
            if isError{return}
            
        }
        APIManager.shared.loginUser(username: username, password: password){[weak self] result in
            switch result{
            case .success(let user):
                DispatchQueue.main.async {
                    
                    if let id = user["id"] as? String{
                        self?.userViewModel.username = user["username"] as! String
                        self?.userViewModel.id = Int(id)!
                        self?.showLoginView = false
                        self?.errorString = ""
                        self?.showAlert = false
                        self?.userViewModel.isUserLogged = true
                        self?.userViewModel.settings.isTokenSaved = true
                    }else {
                        self?.errorString = "Invalid response"
                        self?.showAlert = true
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorString = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
        
    }
}
