//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private(set) var state: AppState = .init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

// MARK: - Singleton shortcut

func appDelegate() -> AppDelegate {
    UIApplication.shared.delegate as! AppDelegate
}
