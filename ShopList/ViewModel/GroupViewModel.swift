//
//  File.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
@MainActor
class GroupViewModel:ObservableObject {
    @Published var userViewModel = UserViewModel()
    @Published var errorString = ""
    @Published var showAlert = false
    @Published var isGroupLoading: Bool = false
    @Published var selectedGroup: Int?
    @Published var usersInSelectedGroup: [[String:Any]] = []
    init(userViewModel: UserViewModel = UserViewModel()) {
        self.userViewModel = userViewModel
    }
    func getgrouplist(){
        APIManager.shared.getGrup(){[weak self] result in
            switch result{
            case .success(let group):
                DispatchQueue.main.async {
                    print(group)
                    self?.userViewModel.groups = group
                   
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorString = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
    @available(iOS 15.0, *)
        func getUserInGroup(group_id:Int) async {
            print("test")
            do {
                let usersInGroup = try await APIManager.shared.getUserGrup(groupId:String(group_id))
                DispatchQueue.main.async {
                    self.usersInSelectedGroup = usersInGroup["user"] as? [[String:Any]] ?? []
                    print("działa")
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    self.errorString = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    func handleGroupTapAsync(index: Int, group_id: Int) {
        Task {
            await handleGroupTap(index: index, group_id: group_id)
        }
    }
    @available(iOS 15.0, *)
        func handleGroupTap(index: Int, group_id: Int) async {
            if selectedGroup == index {
                selectedGroup = nil
            } else if selectedGroup != index {
                isGroupLoading = true
                selectedGroup = index
                await self.getUserInGroup(group_id: group_id)
                isGroupLoading = false
            }
        }
}
