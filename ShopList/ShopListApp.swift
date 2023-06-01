//
//  ShopListApp.swift
//  ShopList
//
//  Created by Dominik Barchański on 13/05/2023.
//

import SwiftUI

@main
struct ShopListApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var userViewModel = UserViewModel()
    var body: some Scene {
        WindowGroup {
            if userViewModel.isUserLogged{
                ContentView().environmentObject(userViewModel)
            }else{
                StartView(viewModel: userViewModel).environmentObject(userViewModel)
            }
            
                }
    }
}
