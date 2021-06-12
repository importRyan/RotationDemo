//  © 2021 Ryan Ferrell. github.com/importRyan


import UIKit

extension UIDevice {
    var isConstrainedScreen: Bool {
        
        let result = (UIScreen.main.bounds.height < 800 && UIScreen.main.bounds.width <= 375)
        print(result)
        return result
    }
}


enum ScreenCategory {
    
    case constrained
    case medium
    case large
    case tablet
    
}

extension UIDevice {
    
    var sizing: ScreenCategory {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return .tablet }
        
        let height = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        if height < 800 && width <= 375 {
            return ( width == 360 && height == 780 ) ? .constrained : .medium
        }
        
        if width == 375 { return .medium }
        
        return .large
    }
}
