//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = RootNavigation()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        let state = appDelegate().state
        state.saveDefaultColor(state.filter.comparatorColor.value)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
    
}
