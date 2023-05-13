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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
