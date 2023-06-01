//
//  BudgetViewModel.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
class BudgetViewModel: ObservableObject{
    @Published var userViewModel: UserViewModel
    init(userViewModel: UserViewModel) {
           self.userViewModel = userViewModel
       }
}
