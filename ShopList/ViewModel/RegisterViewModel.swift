//
//  RegisterViewModel.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject{
    @Published var userViewModel: UserViewModel
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var errorString = ""
    @Published var showLoginView = false
    @Published var emailError = ""
    @Published var usernameError = ""
    @Published var passwordError = ""
    private var cancellables: Set<AnyCancellable> = []
    init(userViewModel: UserViewModel) {
           self.userViewModel = userViewModel
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] email in
                guard !email.isEmpty else { return }
                if !(self?.isValidEmail(email))! {
                    self?.emailError = "Invalid email format"
                } else {
                    self?.emailError = ""
                }
            }.store(in: &cancellables)
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] username in
                guard !username.isEmpty else { return }
                if !(self?.isValidUsername(username))! {
                    self?.usernameError = "Username must be at least 5 characters"
                } else {
                    self?.usernameError = ""
                }
            }.store(in: &cancellables)
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] email in
                guard !email.isEmpty else { return }
                if !(self?.isValidPassword(email))! {
                    self?.passwordError = "Password must be at least 8 characters and (0-9,a-Z,!@#$%^)"
                } else {
                    self?.passwordError = ""
                }
            }.store(in: &cancellables)
       }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidUsername(_ username: String) -> Bool {
        return username.count >= 5
    }
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    func register(){
        emailError = ""
        usernameError = ""
        passwordError = ""
        guard isValidEmail(email) else {
            emailError = "Invalid email format"
            return
        }

        // Check if username length is at least 5
        guard isValidUsername(username) else {
            usernameError = "Username must be at least 5 characters"
            return
        }

        // Check if password is strong
        guard isValidPassword(password) else {
            passwordError = "Password must be at least 8 characters and include one of each (a-Z,!@#$%^&*,0-9)"
            return
        }
        APIManager.shared.registerUser(email: email, username: username, password: password){[weak self] result in
            switch result{
            case .success(let user):
                DispatchQueue.main.async {
                    if let id = user["id"] as? String{
                        self?.userViewModel.username = user["username"] as! String
                        self?.userViewModel.id = Int(id)!
                        self?.showLoginView = false
                        self?.userViewModel.isUserLogged = true
                        self?.userViewModel.settings.isTokenSaved = true
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
