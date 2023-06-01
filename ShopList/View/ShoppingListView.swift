//
//  ShoppingListView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation

import Foundation
import SwiftUI

struct ShoppingListView: View {
    
    @ObservedObject var viewModel: ShoppingListViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                Text("ShoppingList")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.userViewModel.showSettingsView = true
                    }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
            }
            
            .sheet(isPresented: $viewModel.userViewModel.showSettingsView) {
                SettingsView(userViewModel: viewModel.userViewModel)
            }
        }
        
    }
}

