//  © 2021 Ryan Ferrell. github.com/importRyan


import Foundation

enum ColorVision: CaseIterable {
    case typicalTrichromacy
    case deuteranopia
    case protanopia
    case tritanopia
    case monochromacy
    
    public var name: String {
        switch self {
            case .typicalTrichromacy: return "Typical"
            case .deuteranopia: return "Deutan"
            case .protanopia: return "Protan"
            case .tritanopia: return "Tritan"
            case .monochromacy: return "Monochromat"
        }
    }
}

import UIKit

extension ColorVision {
    
    public var bg: UIColor {
        switch self {
            case .typicalTrichromacy: return UIColor.black
            case .deuteranopia: return UIColor(red: 0.000, green: 0.078, blue: 0.422, alpha: 1.000)  // #00136BFF
            case .protanopia: return UIColor(red: 0.016, green: 0.119, blue: 0.440, alpha: 1.000)  // #041E70FF
            case .tritanopia: return UIColor(red: 0.985, green: 0.158, blue: 0.277, alpha: 1.000)  // #FB2846FF
            case .monochromacy: return UIColor(red: 0.211, green: 0.211, blue: 0.211, alpha: 1.000)  // #353535FF
        }
    }
    
    public var text: UIColor {
        switch self {
            case .typicalTrichromacy: return UIColor.white
            case .deuteranopia: return UIColor(red: 0.886, green: 0.737, blue: 0.237, alpha: 1.000)  // #E1BB3CFF
            case .protanopia: return UIColor(red: 0.961, green: 0.809, blue: 0.332, alpha: 1.000)  // #F5CE54FF
            case .tritanopia: return UIColor(red: 0.124, green: 0.909, blue: 0.742, alpha: 1.000)  // #1FE7BDFF
            case .monochromacy: return UIColor(red: 0.786, green: 0.786, blue: 0.786, alpha: 1.000)  // #C8C8C8FF
        }
    }
}
