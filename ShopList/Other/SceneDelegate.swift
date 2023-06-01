import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Użyj UserViewModel do sprawdzenia, czy użytkownik jest zalogowany
        // Jeśli jest zalogowany, ustaw ContentView jako główny widok
        // Jeśli nie jest zalogowany, ustaw LoginView jako główny widok
        let userViewModel = UserViewModel()
        let contentView: AnyView
       
        if userViewModel.isUserLogged{
            contentView = AnyView(ContentView().environmentObject(userViewModel))
        }else {
            contentView = AnyView(StartView(viewModel:userViewModel ).environmentObject(userViewModel))
        }
        

        // Utwórz okno SwiftUI i ustaw je jako główne okno sceny
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    // ... inne metody SceneDelegate
}
