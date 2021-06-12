//  © 2021 Ryan Ferrell. github.com/importRyan


import Foundation

import UIKit

extension UserDefaults {
    
    enum Keys: String {
        case userColor
        case didOnboard
    }
    
    func userColor() -> UIColor? {
        guard let data = data(forKey: Keys.userColor.rawValue) else { return nil }
        do {
            if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor {
                return color
            }
        } catch let error { NSLog(error.localizedDescription) }
        return nil
    }
    
    
    func setUserColor(_ color: UIColor) {
        if let data = makeDataFor(color: color) {
            set(data, forKey: Keys.userColor.rawValue)
        }
    }
    
    func makeDataFor(color: UIColor) -> NSData? {
        try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
    }
    
}

extension UIColor {
    static let defaultColor = UIColor(red: 60 / 255, green: 6 / 255, blue: 57 / 255, alpha: 1)
}
