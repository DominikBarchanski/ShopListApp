//
//  AddUserToGroupView.swift
//  ShopList
//
//  Created by Dominik Barchański on 20/05/2023.
//


import Foundation
import SwiftUI

struct AddUserToGroupView:View{
    @ObservedObject var viewModel: AddUserToGroupViewModel
    
    var body: some View {
        VStack{
            CustomText("Add User To Group \(viewModel.userViewModel.groupNameTo!)")
                .font(.largeTitle)
                .padding()
            CustomTextField(text: $viewModel.email, placeholder: "User email", imageName: "person")
                .padding()
                .background(Color(.init(white: 1, alpha: 0.15)))
                .cornerRadius(10)
                .foregroundColor(.black)
                .autocapitalization(.none)
            Button(action: {
                 viewModel.handleAddUserToGroupCallout()
            }, label:{
                CustomText("create group")
            })
        }
    }
}
