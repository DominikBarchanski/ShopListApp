//
//  ExpenseView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import SwiftUI

struct ExpenseView: View {
    
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showAddExpense = false
    
    var body: some View {
        NavigationView{
            List {
//                ForEach(viewModel.groupedExpenses, id: \.self.key) { key, value in
//                    Section(header: Text(key)) {
//                        ForEach(value) { expense in
//                            HStack {
//                                Text(expense.name)
//                                Spacer()
//                                Text("$\(expense.amount, specifier: "%.2f")")
//                            }
//                        }
//                    }
//                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Expenses", displayMode: .inline)
            .toolbar {
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
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddExpense = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                        }
                    }
                }
            )
            .sheet(isPresented: $showAddExpense) {
//                AddExpenseView(viewModel: viewModel)
            }
        }
    }
}
