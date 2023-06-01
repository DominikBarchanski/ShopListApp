//
//  CreateGroupViewModel.swift
//  ShopList
//
//  Created by Dominik Barchański on 20/05/2023.
//

import Foundation
class CreateGroupViewModel : ObservableObject{
    @Published var userViewModel : UserViewModel
    @Published var groupName = ""
    @Published var errorString = ""
    @Published var showAlert = false
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
    func createGroup(){
        APIManager.shared.createGrup(groupName: groupName){[weak self]result in
            switch result{
            case .success(let group):
                DispatchQueue.main.async {
                    if !group.isEmpty{
                        print(group)
                        var group_to_append = ["id":group["id"], "user_id":1, "group_id": group["id"], "name":
                         group["name"]]
                        self?.userViewModel.groups.append(group_to_append as [String : Any])
                       
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
