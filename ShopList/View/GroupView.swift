//
//  GroupView.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import Foundation
import SwiftUI

enum ActiveSheetGroup: Identifiable {
    case createGroup, addUserToGroup
    
    var id: Int {
        hashValue
    }
}
struct GroupView: View {
    @ObservedObject var viewModel: GroupViewModel
    @State private var activeSheet: ActiveSheetGroup?
    @State private var selectedGroup: Int? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.userViewModel.groups.indices, id: \.self) { index in
                    if let groupName = viewModel.userViewModel.groups[index]["name"] as? String {
                        Section(header:
                            HStack {
                                CustomText("Group")
                                Spacer()
                                Button(action: {
                                    viewModel.userViewModel.groupId = viewModel.userViewModel.groups[index]["group_id"] as? Int
                                    viewModel.userViewModel.groupNameTo = groupName
                                    activeSheet = .addUserToGroup
                                }) {
                                    CustomText("Add User \(viewModel.userViewModel.groups[index]["group_id"] as? Int ?? -1)")
                                    Image(systemName: "plus.circle.fill")
                                }
                            }
                            .accessibilityLabel("Group \(viewModel.userViewModel.groups[index]["group_id"] as? Int ?? -1)")
                        ) {
                            DisclosureGroup(groupName,
                                            isExpanded: .init(
                                                get: { viewModel.selectedGroup == index },
                                                set: { _ in viewModel.handleGroupTapAsync(index: index, group_id: viewModel.userViewModel.groups[index]["group_id"] as! Int) }
                                            )
                            ) {
                                usersContent(index: index)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Groups", displayMode: .inline)
            .onAppear {
                viewModel.getgrouplist()
            }
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
                            activeSheet = .createGroup
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                        }
                    }
                }
            )
            .sheet(item: $activeSheet) { item in
                switch item {
                case .createGroup:
                    CreateGroupView(viewModel: CreateGroupViewModel(userViewModel: viewModel.userViewModel))
                case .addUserToGroup:
                    AddUserToGroupView(viewModel: AddUserToGroupViewModel(userViewModel: viewModel.userViewModel))
                }
            }
        }
    }
    
    private func usersContent(index: Int) -> some View {
        Group {
            if viewModel.selectedGroup == index {
                ForEach(0..<viewModel.usersInSelectedGroup.count, id: \.self) { userIndex in
                    CustomText("User \(viewModel.usersInSelectedGroup[userIndex]["name"] as? String ?? "unknown")")
                }
            }
        }
    }
}
