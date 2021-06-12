//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

class AppState {
    
    var didCompleteOnboarding: Bool
    let filter: FilterState
    
    init() {
        let didOnboard = UserDefaults.standard.bool(forKey: UserDefaults.Keys.didOnboard.rawValue)
        let color = UserDefaults.standard.userColor()
        
        self.didCompleteOnboarding = didOnboard
        self.filter = CIFilterState(startingColor: color ?? .defaultColor)
    }
}

extension AppState {

    func markOnboardingCompleted() {
        UserDefaults.standard.setValue(true, forKey: UserDefaults.Keys.didOnboard.rawValue)
    }
    
    func saveDefaultColor(_ color: UIColor) {
        UserDefaults.standard.setUserColor(color)
    }
    
}
