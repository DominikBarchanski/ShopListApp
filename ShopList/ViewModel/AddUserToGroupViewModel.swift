//
//  AddUserToGroupViewModel.swift
//  ShopList
//
//  Created by Dominik Barchański on 20/05/2023.
//

import Foundation
class AddUserToGroupViewModel : ObservableObject{
    @Published var userViewModel : UserViewModel
    @Published var email : String = ""
    @Published var errorString = ""
    @Published var showAlert = false
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        
    }
    func handleAddUserToGroupCallout() {
        Task {
            await addUserToGroupCallout()
        }
    }
    func addUserToGroupCallout() async {
        do {
            let group = try await APIManager.shared.addUserToGroup(email: email, groupId: String(userViewModel.groupId!))
            DispatchQueue.main.async {
                if !group.isEmpty {
                    // Handle the success case
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorString = error.localizedDescription
                self.showAlert = true
            }
        }
    }
}
