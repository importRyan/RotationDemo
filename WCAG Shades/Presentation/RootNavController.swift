//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

class RootNavigation: UINavigationController {
    
    init() {
        let state = appDelegate().state
        let vc = state.didCompleteOnboarding
            ? CameraScreenVC(filter: state.filter)
            : OnboardingStartVC()
        super.init(rootViewController: vc)
        isNavigationBarHidden = true
        isToolbarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override var shouldAutorotate: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
        ? true
        : UserDefaults.standard.bool(forKey: UserDefaults.Keys.didOnboard.rawValue)
    }

}
