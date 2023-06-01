//
//  CreateGroupView.swift
//  ShopList
//
//  Created by Dominik Barchański on 20/05/2023.
//

import Foundation
import SwiftUI

struct CreateGroupView:View{
    @ObservedObject var viewModel: CreateGroupViewModel
    
    var body: some View {
        VStack{
            CustomText("Create new group")
                .font(.largeTitle)
                .padding()
            CustomTextField(text: $viewModel.groupName, placeholder: "Group Name", imageName: "person")
                .padding()
                .background(Color(.init(white: 1, alpha: 0.15)))
                .cornerRadius(10)
                .foregroundColor(.black)
                .autocapitalization(.none)
            Button(action: {
                viewModel.createGroup()
            }, label:{
                CustomText("create group")
            })
        }
    }
}
