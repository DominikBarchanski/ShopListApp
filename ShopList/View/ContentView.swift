//
//  ContentView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GroupView(viewModel: GroupViewModel(userViewModel: userViewModel))) {
                    CustomText("Go to Manage Groups")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        .accessibilityLabel("Manage Groups button")
                }
                
                NavigationLink(destination: ExpenseView(viewModel: ExpenseViewModel(userViewModel: userViewModel))) {
                    CustomText("Go to ExpensesView")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        .accessibilityLabel("ExpensesView button")
                }
                
                NavigationLink(destination: ShoppingListView(viewModel: ShoppingListViewModel(userViewModel: userViewModel))) {
                    CustomText("Go to ShoppingListView")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        .accessibilityLabel("ShoppingListView button")
                }
                
                NavigationLink(destination: BudgetView(viewModel: BudgetViewModel(userViewModel: userViewModel))) {
                    CustomText("Go to BudgetView")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        .accessibilityLabel("BudgetView button")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomText("Hi \(userViewModel.username)")
                        .accessibilityLabel("Greeting")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingAlert = true
                    }) {
                        CustomText("Log Out")
                    }
                    .accessibilityLabel("Log Out button")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        userViewModel.showSettingsView = true
                    }) {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityLabel("Settings button")
                }
            }
            .sheet(isPresented: $userViewModel.showSettingsView) {
                SettingsView(userViewModel: userViewModel)
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Log out"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .destructive(Text("Log Out")) {
                    userViewModel.reset()
                    print("User logged out")
                },
                secondaryButton: .cancel()
            )
        }
    }
}
