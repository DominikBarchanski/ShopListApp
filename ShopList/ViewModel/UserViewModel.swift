//
//  UserViewModel.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import Combine
import KeychainSwift

class UserViewModel: ObservableObject{
    @Published var settings = SettingsViewModel()
    @Published var username = ""
    @Published var id: Int = 0
    @Published var password = ""
    @Published var isUserLogged: Bool = false
    @Published var showLoginView: Bool = false
    @Published var showRegisterView: Bool = false
    @Published var showSettingsView: Bool = false
    @Published var errorString = ""
    @Published var groupId:Int? = nil
    @Published var groupNameTo:String? = ""
    @Published var showAlert : Bool = false
    @Published var groups:[[String:Any]] = []
    @Published var groupsUser:[String:Any] = [:]
    
    
    func reset(){
        let keychain = KeychainSwift()
        username = ""
        id = 0
        password = ""
        isUserLogged = false
        showLoginView = false
        showRegisterView = false
        showSettingsView = false
        errorString = ""
        showAlert = false
        settings.isTokenSaved = false
        keychain.delete("bearerToken")
    }
    
    
}
